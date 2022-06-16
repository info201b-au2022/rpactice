# We'll wrap our Shiny Gadget in an addin.
# Let's call it 'clockAddin()'.
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
      id <- input$select
      rstudioapi::documentNew(ps_ui_practice_script(id))
      rstudioapi::setCursorPosition(document_position(3,1))
      print("here: begin")
      stopApp()
    })

    observeEvent(input$done, {
      stopApp()
    })
  }

  # We'll use a pane viewer, and set the minimum height at
  # 300px to ensure we get enough screen space to display the clock.
  viewer <- paneViewer(100)
  runGadget(ui, server, viewer = viewer)

}

# Try running the ui
#ui_begin()

