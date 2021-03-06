# ---------------------------------------------------------------------------- #
options = commandArgs(trailingOnly=TRUE)
source(file.path(options[2],'/Argument_Parser.R'))
argv = Parse_Arguments('Annotate_Peaks')


# ---------------------------------------------------------------------------- #
#' Annotate_Peaks
#'
#' @param annotation - list - processed annotation as given by Prepare_Annotation.R
#' @param peaks_path - narrowPeaks/broadPeaks in macs2 output
#' @param outfile    - location of the output file
#' @param peakname   - Name of the peak file
#'
#' @return saves RDS object with an annotated GRanges object
Annotate_Peaks = function(
    annotation = NULL,
    peaks_path = NULL,
    outfile    = NULL,
    peakname   = NULL,
    scriptdir  = NULL
){

    # --------------------------------------------------------------- #
    # checks for default arugments
    deflist = as.list(formals(Annotate_Peaks))
    arglist = as.list(match.call)
    arg.ind = names(deflist) %in% names(arglist)
    if(any(arg.ind))
      stop(paste(paste(names(arglist)[arg.ind], collapse=','),'not defined'))

    # --------------------------------------------------------------- #
    suppressPackageStartupMessages(library(data.table))
    suppressPackageStartupMessages(library(stringr))
    suppressPackageStartupMessages(library(genomation))
    suppressPackageStartupMessages(library(GenomicRanges))
    source(file.path(scriptdir, 'Functions_Helper.R'), local=TRUE)

    # --------------------------------------------------------------- #
    if(file.info(peaks_path)$size > 0){
       
        
        message('Annotation ...')
            annot = readRDS(annotation)
        
        message('Reading peaks ...')    
            peaks  = readGeneric(peaks_path)
    
        message('Annotating peaks ...')      
            peaks$annot = AnnotateRanges(peaks, annot$genomic_annotation)
    }else{
       peaks = list()

    }
    message('Saving annotated peaks ...')
        saveRDS(peaks, outfile)

}



# ---------------------------------------------------------------------------- #
Annotate_Peaks(
    annotation  = argv$input[['annotation']],
    peaks_path  = argv$input[['peaks']],
    outfile     = argv$output[['outfile']],
    peakname    = argv$params[['name']],
    scriptdir   = argv$params[['scriptdir']]
)


# annotation = '/home/vfranke/Tmp/pigxtest/Annotation/Processed_Annotation.rds'
# peaks      = '/home/vfranke/Tmp/pigxtest/Peaks/MACS2/Peaks1/Peaks1_qsort.bed'
# outfile    = '~/Tmp/file.rds'
# peakname   = 'peak1'
# scriptdir  = '/home/vfranke/Projects/AAkalin_PIX/Scripts'
