#----------------------------------------------------------------------------#
# Shiny gadget for selecting one of the loaded practice sets
# See: https://shiny.rstudio.com/articles/gadgets.html
#----------------------------------------------------------------------------#
ui_begin <- function() {

  ui <- miniPage(
    miniTitleBar("Practice INFO 201",
                 right = miniTitleBarButton("done", "Done", primary = TRUE)),
    miniContentPanel(
      selectInput("select",
                  label = h3("Select Practice Set"),
                  choices = ps_ui_get_titles(),
                  selected = 1),
      actionButton("begin", "Begin")
    )
  )

  server <- function(input, output, session) {

    observeEvent(input$begin, {
      short <- input$select
      id <- ps_get_id_by_short(short)
      ps_set_current(id)
      clear_viewer_pane()
      rstudioapi::documentNew(format_practice_script())
      rstudioapi::setCursorPosition(document_position(3,1))
      stopApp()
    })

    observeEvent(input$done, {
      stopApp()
    })
  }
  viewer <- paneViewer(100)
  runGadget(ui, server, viewer = viewer)
}

# Try running the ui
#ui_begin()

test2 <- function() {
  # t <- rstudioapi::askForSecret("xxx", "message ...", "title title")
  t <- rstudioapi::selectDirectory(
    caption = "Select Directory",
    label = "Select",
    path = getActiveProject()
  )
  print(t)
}


