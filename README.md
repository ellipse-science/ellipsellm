# ellipsellm

Super duper minimalist wrapper package 🍬📦 around the OpenAI API. More providers to
come if/when the need arises.

![logo](img.jpg)

## Installation

You can install the development version of ellipsellm like so:

``` r
r$> remotes::install_github("ellipse-science/ellipsellm")
```

To interact with the OpenAI API, you need an API key in your `.Renviron` in the form:

```r
OPENAI_API_KEY=<YOUR_API_KEY_HERE>
```

This package is close to the API, so perusing the [documentation](https://platform.openai.com/docs/api-reference/chat) might help.

## Example

Here is a simple example:

```
r$> library(ellipsellm)
ℹ Loading ellipsellm

[ins] r$> conv <- openai_create_conversation("Why is the sky blue?")

[ins] r$> resp <- openai_chat_completion(conv)

[ins] r$> cli::cli_text(resp$content)
The sky appears blue primarily because of a phenomenon called Rayleigh scattering. As sunlight enters the
Earth's atmosphere, it collides with molecules and small particles. Sunlight, or white light, is made up
of many different colors, each with its own wavelength.

Blue light has a shorter wavelength and is scattered in all directions by the gases and particles in the
atmosphere more than other colors with longer wavelengths, such as red and yellow. This scattering causes
the sky to look blue from our perspective on the ground.

During sunrise and sunset, the sky can appear red or orange because the sunlight has to pass through a
greater thickness of the Earth's atmosphere. This increased distance causes more scattering of the
shorter blue wavelengths, allowing the longer red wavelengths to dominate the sky's color.

[ins] r$> conv2 <-
            conv |>
            openai_continue_conversation(resp$role, resp$content) |>
            openai_continue_conversation("user", "Who discovered Rayleigh scattering?")

[ins] r$> resp2 <- openai_chat_completion(conv2)

[ins] r$> cli::cli_text(resp2$content)
Rayleigh scattering is named after the British scientist Lord Rayleigh, whose full name was John William
Strutt. He discovered and described this scattering phenomenon in the 19th century. Lord Rayleigh's work
on the scattering of light helped explain why the sky is blue during the day and why it changes color at
sunrise and sunset. His contributions to the field of physics were significant, and he was awarded the
Nobel Prize in Physics in 1904 for his investigations of the densities of the most important gases and
for his discovery of argon in connection with these studies.
```

## Useful tidbits

Good to know:

* `openai_create_conversation` and `openai_continue_conversation` are just helpers to make lists (inspect their outputs).
* `openai_chat_completion` has a `model` parameter, see [Models](https://platform.openai.com/docs/models).
* All optional chat completion parameters can be passed to `openai_chat_completions` through the `api_params` named list. See [the docs](https://platform.openai.com/docs/api-reference/chat/create).
