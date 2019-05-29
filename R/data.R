#' Dataset of mice under chow and high fat dier
#'
#' A list containing genomic data of BXD mice
#' @name bxd
#' @format A list of three data frames with 64 rows (BXD data set)
#' \describe{
#'   \item{metabo}{Metabolomic quantification}
#'   \item{prot}{Protein abondance}
#'   \item{RNA}{Gene expression}
#' }
#' @source \url{http://www.genenetwork.org/webqtl/main.py?FormID=sharinginfo&GN_AccessionId=714}
NULL

#' Dataset of patients with liver cancer
#'
#' A data frame containing clinical data for liver cancer dataset
#' @name clinical_data
#' @format A data frame with 360 rows and 15 variables
#' \describe{
#'   \item{years_to_birth}{Year of birth}
#'   \item{Tumor_purity}{Tumor purity}
#'   \item{pathologic_stage}{Pathologic stage of tumor}
#'   \item{pathology_T_stage}{Pathologic stage of tumor}
#'   \item{pathology_N_stage}{Pathologic stage of tumor}
#'   \item{pathology_M_stage}{Pathologic stage of tumor}
#'   \item{histological_type}{Histological type of tumor}
#'   \item{gender}{Gender of patient}
#'   \item{radiation_therapy}{Radiation therapy (yes or no)}
#'   \item{residual_tumor}{Residual tumor}
#'   \item{race}{Race}
#'   \item{ethnicity}{Ethnicity}
#'   \item{overallsurvival}{Survival time}
#'   \item{status}{Death status}
#'   \item{overall_survival}{Survival time (rounded)}
#' }
#' @source \url{http://www.linkedomics.org/}
NULL

#' Dataset of patients with liver cancer
#'
#' A data frame containing genomic data for liver cancer dataset
#' @name liver
#' @format A list of data frame with 360 rows
#' \describe{
#'   \item{meth}{Methylation data}
#'   \item{mutation}{Mutation data}
#'   \item{RNA}{Gene expression data}
#'   \item{CNV}{Copy number variation data}
#' }
#' @source \url{http://www.linkedomics.org/}
NULL


#' Dataset of obsese individuals
#'
#' A data frame containing genomic data for obesity dataset
#' @name obesity
#' @format A list of data frame with 26 rows
#' \describe{
#'   \item{meth}{Methylation data}
#'   \item{mRNA}{Gene expression data}
#'   \item{miRNA}{miRNA data}
#' }
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE58248}
NULL

