library(dplyr)
path <- 'inst/extdata'
directory <- 'BXD'

## Metabo ## Remove useless columns
metabo_CD <- read.delim(list.files(file.path(path, directory), pattern="metabo_CD", full.names=TRUE), skip=33)[, -c((1:9),11:15, 56)]
metabo_HFD <- read.delim(list.files(file.path(path, directory), pattern="metabo_HFD", full.names=TRUE), skip=33)[, -c((1:9),11:15, 54)]
metabo <- cbind(metabo_CD[,-1], metabo_HFD[,-1]) %>% t## Remove Aliases column
colnames(metabo) <- metabo_CD[,"Aliases"]
rownames(metabo) <- c(colnames(metabo_CD[,-1]),paste(colnames(metabo_HFD[,-1]), "HFD", sep=".")) 
## Prot

prot_CD <- read.delim(list.files(file.path(path, directory), pattern="prot_CD", full.names=TRUE), skip=33)[, -c((1:9),11:14, 53)]
prot_HFD <- read.delim(list.files(file.path(path, directory), pattern="prot_HFD", full.names=TRUE), skip=33)[, -c((1:9),11:14, 50)]
prot <- cbind(prot_CD[,-1], prot_HFD[,-1]) %>% t
colnames(prot) <- prot_CD[,"Aliases"]
rownames(prot) <- c(colnames(prot_CD[,-1]),paste(colnames(prot_HFD[,-1]), "HFD", sep=".")) 

##RNA
RNA_CD <- read.delim(list.files(file.path(path, directory), pattern="RNA_CD", full.names=TRUE), skip=33)[, -c((1:9),11:14, 56)]
RNA_HFD <- read.delim(list.files(file.path(path, directory), pattern="RNA_HFD", full.names=TRUE), skip=33)[, -c((1:9),11:14, 55)]
RNA <- cbind(RNA_CD[,-1], RNA_HFD[,-1]) %>% t
colnames(RNA) <- RNA_CD[,"Aliases"]
rownames(RNA) <- c(colnames(RNA_CD[,-1]),paste(colnames(RNA_HFD[,-1]), "HFD", sep=".")) 

dat <- list(metabo=metabo, prot=prot, RNA=RNA)

id_num <- sapply(dat, rownames)
id_sub <- Reduce(intersect, id_num)

bxd <- lapply(dat, function (dd){
  dd[id_sub,] %>% t %>% na.omit %>% t ## Remove na values
})

save(bxd,"data/bxd.rda")

