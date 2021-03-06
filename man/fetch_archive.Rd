% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/api-archive.R
\name{fetch_archive}
\alias{fetch_archive}
\title{Fetch a file or object from an archive}
\usage{
fetch_archive(target_name, path_prefix = NULL, archive_file = "remake.zip")
}
\arguments{
\item{target_name}{Name of a single file or}

\item{path_prefix}{Optional path prefix for exported files only
(not for objects).  If given, a file \code{path/to/file} will be
exported as \code{path_prefix/path/to/file}; this is useful to avoid
overwriting existing data, as this will happen without warning.}

\item{archive_file}{Name of the archive file to use, by
default \code{remake.zip}.}
}
\value{
If \code{target_name} refers to an object, then the return
value is the restored object.  If \code{target_name} refers to a
file, then the return value is the path to the restored file
(including \code{path_prefix} if given).
}
\description{
Fetch a file or object from an archive.  Throws an error if
requesting a target that was not exported (see
\code{\link{list_archive}} for archive contents).
}
\author{
Rich FitzJohn
}

