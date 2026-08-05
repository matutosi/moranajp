# Morphological analysis for Japanese text by web chamame

Using https://chamame.ninjal.ac.jp/ and rvest. Because it uses an
internet resource, it fails gracefully: when the web service is not
available or its response has changed, shows a message and returns
`NULL` instead of an error.

Submits a text to web chamame and parses the response. Errors are
handled by web_chamame().

Selects the fields by name, NOT by index: web chamame sometimes adds
fields, which shifts all the indices. Errors are handled by
web_chamame().

The names of the output items of web chamame, in the same order as
`out_cols_chamame()`. Only a few items are requested, so the header row
of the result corresponds to the cells and the columns can be selected
by their names.

Web chamame returns a table even when the analysis failed, e.g. a table
with an error page of the server. The positions of the columns are also
checked, because they change when web chamame changes its output items.
Errors are handled by web_chamame().

Helper function to fail gracefully when an internet resource is not
available, as required by the CRAN repository policy.

## Usage

``` r
out_cols_chamame(col_lang = "jp")

web_chamame(
  text,
  col_lang = "jp",
  dic = "unidic-spoken",
  url = "https://chamame.ninjal.ac.jp/index.html"
)

submit_chamame(html, text, col_lang = "jp", dic = "unidic-spoken")

select_chamame_fields(form, dic = "unidic-spoken")

chamame_field(field, item)

cols_chamame()

extract_chamame_cols(tbl, col_lang = "jp")

check_chamame_table(tbl)

read_html_safely(url)

msg_not_available(url, cnd)

html_radio_set(form, ...)

is_radio(fields)
```

## Arguments

- col_lang:

  A text. "jp" or "en"

- text:

  A text.

- dic:

  A text. Dictionary of web chamame, e.g. "unidic-spoken", "gendai" or
  "ipadic". Use the value of the dictionary checkbox in the form.

- url:

  A text. URL to read.

- html:

  A xml_document of web chamame.

- form:

  vest_form object

- field:

  A field in a rvest_form object.

- item:

  A string to specify the item of `field`.

- tbl:

  A dataframe parsed from the response of web chamame.

- cnd:

  A try-error object.

- ...:

  dynamic-dots Name-value pairs giving radio button to modify.

- fields:

  \$fields in vest_form object

## Value

A character vector

A dataframe, or `NULL` when web chamame is not available.

A dataframe

A rvest_form object

A string

A character vector

A dataframe

A dataframe

A xml_document, or `NULL` when the resource is not available.

A string

vest_form object

A boolean or vector

## Examples

``` r
if (FALSE) { # \dontrun{
  # Need to connect https://chamame.ninjal.ac.jp/ .
text <-
  paste0("\\u3059",
         paste0(rep("\\u3082",8),collapse=""),
         "\\u306e\\u3046\\u3061") |>
  unescape_utf()
web_chamame(text)
} # }
```
