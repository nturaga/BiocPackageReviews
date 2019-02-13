template <-
    function(package)
{
    tmpl <- paste0(
        "Package review for ", package, "\n",
        "==================================", "\n",
        "## R CMD build", "\n",
        "%s", "\n",
        "## R CMD check", "\n",
        "%s", "\n",
        "## General", "\n",
        "%s", "\n",
        "## DESCRIPTION", "\n",
        "%s", "\n",
        "## NAMESPACE", "\n",
        "%s", "\n",
        "## man", "\n",
        "%s", "\n",
        "## vignette", "\n",
        "%s", "\n",
        "## R", "\n",
        "%s", "\n",
        collapse=""
    )
    tmpl
}
