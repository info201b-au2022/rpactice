library(shiny)
library(miniUI)

# We'll wrap our Shiny Gadget in an addin.
# Let's call it 'clockAddin()'.
ui_begin <- function() {

  ui <- miniPage(
    miniTitleBar("Practice INFO 201"),
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
      t <- practice.begin(id)
      file_header <- str_replace(ps_heading(), "\n", "\n# ")
      rstudioapi::documentNew(paste0("# ", file_header ))
      rstudioapi::setCursorPosition(document_position(3,1))
      practice.questions()
      print("here: begin")
      stopApp()
    })

    observeEvent(input$check_me, {
      t <- practice.check_format()
      output$feedback <- renderText({t})
      print(t)
      print("here:check_me")
      t
    })
  }

  # We'll use a pane viwer, and set the minimum height at
  # 300px to ensure we get enough screen space to display the clock.
  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}

# Try running the clock!
#ui_begin()

