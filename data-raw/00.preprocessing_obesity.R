library(GEOquery)
library(stringr)
library(dplyr)
## Load data from GEO
gse_miRNA <- getGEO('GSE58248',GSEMatrix = FALSE)
gse_mRNA <- getGEO('GSE58249',GSEMatrix = FALSE)
gse_meth <- getGEO('GSE58280',GSEMatrix = FALSE)
gse <- list(gse_miRNA, gse_mRNA, gse_meth)

## Extract Tables
data <- lapply(gse, function(gg){
  probesets <- Table(GPLList(gg)[[1]])$ID
  # make the data matrix from the VALUE columns from each GSM
  # being careful to match the order of the probesets in the platform
  # with those in the GSMs
  data.matrix <- do.call('cbind',lapply(GSMList(gg),function(x){
    tab <- Table(x)
    mymatch <- match(probesets,tab$ID_REF)
    print(dim(tab))
    return(tab$VALUE[mymatch])
  }))
  rownames(data.matrix) <- probesets
  return(data.matrix)
})

## Match GSM to id numbers
### Methylation
GSM_meth <- sapply(GSMList(gse_meth), function(gg) gg@header$geo_accession)
GSM_dat_meth <- colnames(data[[3]])
GSM_meth %>% match(GSM_dat_meth)
#### Extract number
n_meth <- str_extract(sapply(GSMList(gse_meth), function(gg) gg@header$title), pattern = "[1-9]+")
#### Extract status post activity or pre activity
status_meth <- str_extract(sapply(GSMList(gse_meth), function(gg) gg@header$title), pattern = "P.*") %>% toupper
#### Create id_number
id_meth <- paste(n_meth,status_meth, sep = "_")

### mRNA
GSM_mRNA <- sapply(GSMList(gse_mRNA), function(gg) gg@header$geo_accession)
GSM_dat_mRNA <- colnames(data[[2]])
idx <- GSM_dat_mRNA %>% match(GSM_mRNA)
split_mRNA <- str_split(sapply(GSMList(gse_mRNA), function(gg) gg@header$title), "-")[idx]
n_mRNA <- sapply(split_mRNA, function(ss) ss[[2]])
status_mRNA <- sapply(split_mRNA, function(ss) ss[[1]]) %>% toupper
id_mRNA <- paste(n_mRNA,status_mRNA, sep = "_")

na_genes <- which(gse_mRNA@gpls$GPL10558@dataTable@table$RefSeq_ID=="")

### miRNA

GSM_miRNA <- sapply(GSMList(gse_miRNA), function(gg) gg@header$geo_accession)
GSM_dat_miRNA <- colnames(data[[1]])
GSM_miRNA %>% match(GSM_dat_miRNA)
split_miRNA <- str_split(sapply(GSMList(gse_miRNA), function(gg) gg@header$title), "_")
type_miRNA <- sapply(split_miRNA, function(ss) ss[[1]])

n_miRNA <- sapply(split_miRNA, function(ss) ss[[2]])
status_miRNA <- sapply(split_miRNA, function(ss) ss[[3]])
id_miRNA <- paste(n_miRNA,status_miRNA, sep = "_")

df_type <- cbind(type_miRNA, id_miRNA)
rownames(df_type) <- id_miRNA

### Check the common patients between all the datasets
gplots::venn(list(meth = id_meth, miRNA = id_miRNA, mRNA = id_mRNA))

##Filters
### Remove rows with NA for all datasets and rename columns (GSM to id_number)
data_meth <- data[[3]] %>% na.omit
colnames(data_meth) <- id_meth

data_mRNA <- data[[2]][-na_genes, ] %>% na.omit
rownames(data_mRNA) <- gse_mRNA@gpls$GPL10558@dataTable@table$Symbol[-na_genes]
colnames(data_mRNA) <- id_mRNA

data_miRNA <- data[[1]] %>% na.omit
colnames(data_miRNA) <- id_miRNA
### Create list of data
dat <- list(meth = data_meth, mRNA = data_mRNA, miRNA = data_miRNA)


### Save data
pat <- Reduce(intersect,lapply(dat, colnames))
final_dat <- sapply(dat, function(dd) dd[,pat] %>% t) ## Transpose (patients in rows)
pat_names <- paste(df_type[final_dat$meth %>% rownames(),"id_miRNA"], df_type[final_dat$meth %>% rownames(),"type_miRNA"], sep="_")
obesity <- lapply(final_dat, function(ff){
  rownames(ff) <- pat_names
  ff
})

saveRDS(obesity, "data/obesity.rda")
