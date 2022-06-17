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
      rstudioapi::documentNew(format_practice_script(id))
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

