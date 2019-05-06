.github_userpwd <-
    function()
{
    paste(
        getOption("bioc_contributions_github_user"),
        getOption("bioc_contributions_github_auth"),
        sep=":")
}


.github_download <-
    function(issue,
             download_path="~/Documents/bioc/package_reviews")
{
    message("downloading ", sQuote(issue$title))
    repos <- sub(".*Repository: *([[:alnum:]/:\\.-]+).*", "\\1",
                 issue$body)

    path <- sprintf("/issues/%d/comments", issue$number)
    # Check additional package
    comments <- .github_get(path)
    tag <- "AdditionalPackage: *([[:alnum:]/:\\.-]+).*"
    for (comment in comments) {
        if (!grepl(tag, comment$body))
            next
        repos <- c(repos,
                   sub(tag, "\\1", comment$body))
    }
    ## Download package
    owd <- setwd(download_path)
    for (repo in repos) {
        if (!file.exists(basename(repo))) {
            system2("git", sprintf("clone --depth 1 %s", repo),
                    stdout=TRUE, stderr=TRUE)
        } else {
            root <- setwd(basename(repo))
            system2("git", "pull")
            setwd(root)
        }
    }   
    setwd(owd)
}


#' @importFrom httr GET
#' @importFrom httr config
#' @importFrom httr accept
#' @importFrom httr stop_for_status
#' @importFrom httr content
.github_get <-
    function(path, api="https://api.github.com",
             path_root="/repos/Bioconductor/Contributions")
{
    query <- sprintf("%s%s%s", api, path_root, path)
    response <- GET(
        query,
        config(userpwd=.github_userpwd(), httpauth=1L),
        accept("application/vnd.github.v3+json"))
    stop_for_status(response)
    content(response)
}


#' Download packages assigned to core-developer
#'
#' This function only works when a valid github username and password
#' are supplied to the function BiocPackageReview:::.github_userpwd()
#' 
#' @param assignee character indicating the github username of
#'     core-team member
#'
#' @examples
#' get_issue_assignee(assignee="nturaga")
#'
#' @export
get_issues_assignee <-
    function(assignee)
{
    issues <- .github_get(path="/issues?page=1&per_page=100")
    for (issue in issues) {
        if (assignee %in% issue$assignee$login) {
            .github_download(issue)
            print(issue$url)
        }
    }
}


