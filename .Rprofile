options(repos=structure(c(CRAN="http://cran.case.edu")))
options("width"=160)
setHook(packageEvent("grDevices", "onLoad"),
        function(...) grDevices::X11.options(title="R Graphics: Device %d", width=8, height=8, xpos=0))
