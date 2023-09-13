![ggtips Logo](https://github.com/cosi1/ggtips/blob/master/.github/logo.svg?raw=true)

# ggtips - interactive tooltips for ggplots

![Build Status](https://github.com/cosi1/ggtips/actions/workflows/main.yml/badge.svg)

R package that provides a set of functions to enhance your ggplots with
eye-pleasing tooltips easily, and render them in your Shiny apps.

### Preview

![plot with tooltips](inst/example/ggtips.png?raw=true)


[Demo shiny app](https://jcubic.shinyapps.io/ggtips/)

### Installation

To install ggtips, use devtools:

```
devtools::install_github("Roche/ggtips")
```

### Usage:

The main function - `renderWithTooltips()` - works similar to Shiny's `renderUI()`.
To use it in your app, define an `uiOutput` element in the UI section (this will
be the container for your plot), and substitute `renderPlot()` in your server logic
with `renderWithTooltips()`, providing a list of variables you want to see in the tooltips:

```R
output[["myPlot"]] <- renderWithTooltips(
  plot = ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) + geom_point(aes(colour = Species)),
  varDict = list(Sepal.Width = "Width", Sepal.Length = "Length", Species = "Species")
)
```

`renderWithTooltips` function accepts also optional `customGrob` parameter. It
allows to pass modified grob object and as a result output tooltips coordinates
will fits its geometries. This is useful if you want to add any extra geometry
 to your plot, e.g. bar with information or warning.

If you want to save svg (e.g. you're using cache'ing) use longer code:

```R
cache <- list() ## instead of list you can save data in data base like mongoDB
output[["myPlot"]] <- renderUI({
  ## generate hash for this plot
  ## https://stackoverflow.com/q/24192570/387194
  hash <- generateHash(plot)
  if (is.null(cache[[hash]]) {
    res <- ggtips::getSvgAndTooltipdata(
      plot = plot,
      varDict = varDict
    )
    cache[[hash]] <- res
  } else {
    res <- cache[[hash]]
  }
  ggtips::htmlWithGivenTooltips(
    svg = res$svg,
    data = res$data,
    height = height
  )
})
```

## new API added in version 0.3.0

```R
output[["myPlot"]] <- renderUI({
  plot = ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length)) + geom_point(aes(colour = Species))
  varDict = list(Sepal.Width = "Width", Sepal.Length = "Length", Species = "Species")

  ggtips::plotWithTooltips(plot, varDict = varDict)
})
```

`plotWithTooltips` function accept same parameters as `renderWithTooltips`.

### Options

* plot - ggplot object
* varDict - list of data to render on the tooltip that will be extracted from
  ggplot (keys are read data names and values are labels on tooltips)
* customGrob - original grob object that can have grob manipulation
* callback - function that can be used, to put additional data into
  tooltip, it should return string
* width/height - number
* point.size - size of the points

See our demo application (type `ggtips::demo()`) for example usage.

### Docker demo

Optionally you can also build a Dockerized version of the demo:

`sudo docker build -t ggtips -f inst/Dockerfile .`

After building the docker image (which can take a while) use the command:

```
docker run -p 3838:3838 ggtips
```

The docker image starts in interactive mode (which means you can use ctrl+c to
stop it) and exposes the web browser at port 3838.

Depending on your Docker setup, the exposed application may be available under:

[http://localhost:3838](http://localhost:3838)

or may be exposed through the locally running *docker-machine*, which is the typical
case with the Windows operating system that have no Hyper-V enabled. You can find
more information about it on
[Hyper-V on Windows](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/hyper-v-requirements).

If your Docker setup is using *docker-machine*, you can find it's IP using
command `docker-machine ip`, then use the `http://{docker machine IP}:3838`
address to connect to demo session.

See [Docker setup tutorial](https://docs.docker.com/get-started) to learn more
about configuring Docker and
[Docker Machine Documentation](https://docs.docker.com/machine/get-started/)
to learn about *docker-machine* itself.

## Acknowledge
* The library uses [jQuery.resize](https://github.com/jcubic/jquery.resize) by [Jakub T. Jankiewicz](https://github.com/jcubic).
* Logo designed by [Jakub T. Jankiewicz](https://github.com/jcubic).

## Maintainers
* [Paweł Piątkowski](https://github.com/cosi1)
* [Jakub T. Jankiewicz](https://github.com/jcubic)

## Other Contributors
<!-- CONTRIBUTORS-START -->
* [Marcin Kamianowski](https://github.com/marcin-kam)
* [Michał Jakubczak](https://github.com/mjakubczak)
* [Ewa Ostrowiecka](https://github.com/ewaostrowiecka)
* [Adam Golubowski](https://github.com/adamgolubowski)
* [Jakub Malecki](https://github.com/OliBravo)
* [Zygmunt Zawadzki](https://github.com/zzawadz)
<!-- CONTRIBUTORS-END -->
