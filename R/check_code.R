#' This function captures BiocCheck output
#'
#' @importFrom BiocCheck BiocCheck
capture_BiocCheck_output<-
    function(package)
{
    res <- BiocCheck::BiocCheck(package)
    warnings <- paste0("[REQUIRED]:",
                     res$warning, "\n")
    note <- paste0("[REQUIRED]:",
                  res$note, "\n")
    output <- c(note, warnings)
    paste0(output, collapse='')
}


#' Make a markdown report
#' @param package Take the package path
#' @export
make_markdown_report <-
    function(package)
{
    tmpl <- template(basename(package))
    ## general
    general <- capture_BiocCheck_output(package)
    ## build
    build <- ""
    ## check
    check <- ""
    ## description
    description <- ""
    ## namespace
    namespace <- ""
    ## man
    man <- ""
    ## vignette
    vignette <- ""
    ## rcheck
    rcheck <- ""
    ## make markdown review
    review <- sprintf(tmpl,
                      build,
                      check,
                      general,
                      description,
                      namespace,
                      man,
                      vignette,
                      rcheck
                      )
    review
}
