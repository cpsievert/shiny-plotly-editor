library(shiny)
library(plotly)

editor_url <- "https://shiny-plotly-editor.cpsievert.me"

ui <- fluidPage(
  fluidRow(
    column(
      4,
      selectInput("var", "Choose a variable", names(diamonds)),
      actionButton("btn", "Edit chart")
    ),
    column(8, plotlyOutput("p"))
  )
)

server <- function(input, output, session) {

  plot_reactive <- reactive({
    plot_ly(x = diamonds[[input$var]])
  })

  output$p <- renderPlotly({
    plot_reactive()
  })

  observeEvent(input$btn, {

    json <- plotly_json(plot_reactive())

    res <- session$registerDataObj(
      "plotly_graph", json$x$data,
      function(data, req) {
        httpResponse(
          status = 200,
          content_type = 'application/json',
          content = data,
          headers = list(
            "Access-Control-Allow-Origin" = editor_url
          )
        )
      }
    )

    url <- getEditorUrl(session, res)
    browseURL(url)
  })

  getEditorUrl <- function(session, path_object) {
    cd <- session$clientData
    sprintf(
      "%s/?plotURL=%s//%s:%s%s%s",
      editor_url,
      cd$url_protocol,
      cd$url_hostname,
      cd$url_port,
      cd$url_pathname,
      path_object
    )
  }

}

shinyApp(ui, server)
