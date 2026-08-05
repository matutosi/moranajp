# Check that web chamame still returns the expected columns.
#
# Uses the internet, so this is NOT a test in tests/.
# Run it after web chamame changes, or before submitting to CRAN.
#
#   Rscript --vanilla data-raw/check_chamame.R
#
# The result is compared with the stored `neko_chamame`,
# which was made before the package was archived on CRAN.
# A few rows differ when web chamame updates its dictionary
# (e.g. "この頃" was split into "この" and "頃" in 2025),
# so check the differences instead of expecting a perfect match.

devtools::load_all(quiet = TRUE)

now <- moranajp_all(unescape_utf(neko)[1:2, ], method = "chamame")
if(is.null(now)){
  stop("web chamame is not available")
}
old <- unescape_utf(neko_chamame)[seq_len(nrow(now)), ]

cols <- colnames(now)
for(cl in cols){
  same <- sum(now[[cl]] == old[[cl]], na.rm = TRUE)
  cat(sprintf("%-14s %d / %d identical\n", cl, same, nrow(now)))
}

d <- which(Reduce(`|`, lapply(cols, function(cl) now[[cl]] != old[[cl]])))
cat("\ndiffering rows:", paste(d, collapse = ", "), "\n")
for(i in d){
  cat("row ", i, "\n",
      "  now: ", paste(unlist(now[i, ]), collapse = " | "), "\n",
      "  old: ", paste(unlist(old[i, ]), collapse = " | "), "\n", sep = "")
}
