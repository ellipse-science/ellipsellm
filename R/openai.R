#' Create an OpenAI chat completion conversation
#'
#' @param user_message A prompt in ChatGPT parlance.
#' @param system_message Instruction to guide the behavior and personality of the model throughout the conversation.
#'   A default one will be provided free of charge.
#'
#' @returns A list of lists. Each element of the outer list contains a role and a message.
#' @export
openai_create_conversation <- function(user_message, system_message = NULL) {
  if (is.null(system_message)) {
    system_message <- "You are a helpful assistant."
  }
  return(list(
    list(role = "system", content = system_message),
    list(role = "user",   content = user_message)
  ))
}

#' Continue an existing OpenAI cat completion conversation
#'
#' @param conversation The conversation so far. List of lists.
#' @param role The role for the message we are adding to the conversation.
#'   One of `user`, `system` or `assistant`.
#' @param content The message to add to the conversation.
#'
#' @returns A list of lists. The existing conversation with our message added.
#' @export
openai_continue_conversation <- function(
  conversation,
  role = c("user", "system", "assistant"),
  content
) {
  role <- match.arg(role)
  len <- length(conversation)
  conversation[[len + 1]] <- list(role = role, content = content)
  return(conversation)
}

#' Send a request to the OpenAI chat completion endpoint
#'
#' @param messages The conversation up to now. Make one from scratch with
#'   `openai_create_conversation`.
#' @param model The model to use. Defaults to the "best/cheapest" choice at time of writing.
#' @param api_params All other API parameters are optional. Provide them inside  a named list and they will be sent
#'  as-is.
#' @param api_key The OpenAI API key to use. Defaults to env var `OPENAI_API_KEY`.
#'
#' @returns An `httr2` response object if there was a problem. A named list containing `role` and `content` elements
#'   otherwise.
#' @export
openai_chat_completion <- function(
  messages,
  model = "gpt-4o-2024-08-06",
  api_params = list(temperature = 0.8),
  api_key = get_openai_api_key()
) {
  req <- httr2::request("https://api.openai.com/v1/chat/completions")
  resp <-
    req |>
    httr2::req_headers(`Content-Type` = "application/json",
                       Authorization  = glue::glue("Bearer {api_key}")) |>
    httr2::req_body_json(c(list(model = model,
                                messages = messages),
                           api_params)) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) != 200) {
    cli::cli_alert_danger("HTTP request failed. See the response for details")
    return(resp)
  } else {
    return(openai_process_response(resp))
  }
}

openai_process_response <- function(resp) {
  body <- httr2::resp_body_json(resp)
  return(list(role = body$choices[[1]]$message$role,
              content = body$choices[[1]]$message$content))
}

get_openai_api_key <- function() {
  key <- Sys.getenv("OPENAI_API_KEY")
  if (identical(key, "")) {
    stop("No API key found, please supply with `api_key` argument or with OPENAI_API_KEY env var") # nolint
  }
  return(key)
}
