# author: Iraitz Montalban
# date: May, 2023

.state <- new.env(parent = emptyenv()) #create .state when package is first loaded

start_plumber <- function(path, port) {
  trml <- rstudioapi::terminalCreate(show = FALSE)
  rstudioapi::terminalSend(trml, "R\n") 
  Sys.sleep(2)
  cmd <- sprintf('plumber::plumb("%s")$run(port = %s)\n', path, port)
  rstudioapi::terminalSend(trml, cmd)
  
  .state[["trml"]] <- trml #store terminal name
  invisible(trml)
}

kill_plumber <- function() {
  rstudioapi::terminalKill(.state[["trml"]]) #access terminal name
}