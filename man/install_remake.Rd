% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/api.R
\name{install_remake}
\alias{install_remake}
\title{Install running script.}
\usage{
install_remake(destination_directory, overwrite = FALSE)
}
\arguments{
\item{destination_directory}{Directory to install `remake` to.
Should be on your path, though the current directory may be useful
too.  The file will be installed as \code{file.path(dest,
"remake")}}

\item{overwrite}{Overwrite an existing file?}
}
\description{
Install running script to a local directory.  This directory
should be on the \code{$PATH}.  Once this has been done, you can
run remake with `remake`.  See `remake --help` for more
information, or a summary below.
}
\details{
The installed script is just a wrapper to an internal remake
function, designed so that the wrapper script does not need to be
installed after upgrading remake.

Because of the design of \code{\link{Rscript}}, the helper script
loads the method package: in my experience many things just do not
work without that package loaded and Rscript does not load it by
default (especially in conjunction with \code{::}).

This \code{remake} script accepts standard unix-style command-line
options to drive a subset of remake's functionality.  Supported
featues are:

\itemize{
\item Running \code{remake::make}, as \code{remake target1
[target2]}.  If targets are ommitted the default target will be
used.

\item listing targets, as \code{--list-targets}, which calls
\code{\link{list_targets}}

\item generating a script with \code{-s} or \code{--script}
(printing to standard output) or \code{--script-file} prints to a
file.

\item return the version, as \code{-v} or \code{--version},
returning \code{packageVersion("remake")}
}

Additionally, the file used can be selected by using \code{-f} or
\code{--file} (following \code{make}'s convention), and remake can
be run with \code{verbose=FALSE} by passing in \code{-q} or
\code{--quiet}.
}

