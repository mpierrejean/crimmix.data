#########################################
## http://www.linkedomics.org/login.php
#########################################

library(dplyr)

mutation_data <- read.delim("http://linkedomics.org/data_download/TCGA-LIHC/Human__TCGA_LIHC__WUSM__Mutation__GAIIx__01_28_2016__BI__Gene__Firehose_MutSig2CV.cbt",
                            stringsAsFactors = FALSE)
rownames(mutation_data) <- mutation_data[,1]
mutation_data <- mutation_data[, -1]
download.file("http://linkedomics.org/data_download/TCGA-LIHC/Human__TCGA_LIHC__JHU_USC__Methylation__Meth450__01_28_2016__BI__Gene__Firehose_Methylation_Prepocessor.cct.gz", destfile = "inst/extdata/TCGA/Liver/meth.cct")
meth_data <- read.delim("inst/extdata/TCGA/Liver/meth.cct", stringsAsFactors = FALSE)
rownames(meth_data) <- meth_data[,1]
meth_data <- meth_data[, -1]
meth_data <- na.omit(meth_data)
download.file("http://linkedomics.org/data_download/TCGA-LIHC/Human__TCGA_LIHC__UNC__RNAseq__HiSeq_RNA__01_28_2016__BI__Gene__Firehose_RSEM_log2.cct.gz", destfile = "inst/extdata/TCGA/Liver/RNA.cct")

RNA_data <- read.delim("inst/extdata/TCGA/Liver/RNA.cct", stringsAsFactors = FALSE)
rownames(RNA_data) <- RNA_data[,1]
RNA_data <- RNA_data[, -1]

download.file("http://linkedomics.org/data_download/TCGA-LIHC/Human__TCGA_LIHC__BI__SCNA__SNP_6.0__01_28_2016__BI__Gene__Firehose_GISTIC2_threshold.cgt.gz", destfile = "inst/extdata/TCGA/Liver/CNV.cct")
CNV_data <- read.delim("inst/extdata/TCGA/Liver/CNV.cct" , stringsAsFactors = FALSE)
rownames(CNV_data) <- CNV_data[,1]
CNV_data <- CNV_data[, -1]

meth_pat <- colnames(meth_data)
mut_pat <- colnames(mutation_data)
RNA_pat <- colnames(RNA_data)
CNV_pat <- colnames(CNV_data)

patients <- Reduce(intersect, list(meth_pat,mut_pat,RNA_pat, CNV_pat))

data <- list(meth = meth_data, mutation = mutation_data, RNA = RNA_data, CNV = CNV_data)
##### Formatting and save
liver <- lapply(data, function(dd){
  dd[,patients] %>% t
})
sapply(liver, dim)
save(liver, file = "data/liver.rda")

## Clinical
clinical_data <- read.delim("http://linkedomics.org/data_download/TCGA-LIHC/Human__TCGA_LIHC__MS__Clinical__Clinical__01_28_2016__BI__Clinical__Firehose.tsi", stringsAsFactors = FALSE)
rownames(clinical_data) <- clinical_data[,1]
clinical_data <- clinical_data[, -1]
clinical_data <- clinical_data[, patients] %>% t
clinical_data <- clinical_data %>% as.data.frame()
save(clinical_data, file = "data/clinical_data.rda")





