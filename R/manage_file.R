
#' @title Lecture des fichiers de donnée
#'
#' @description
#' Fonction de lecture de fichiers csv
#'
#' @param path Chaîne de caractère. Chemin du fichier csv.
#' @param erase_zero Booléen. Remplace les valeurs nulle par \code{NA_real_}
#' (par défaut : \code{TRUE}).
#' @param sep Chaine de caractère. Séparateur de colonne (par défaut :
#' \code{;}).
#' @param dec Chaine de caractère. Séparateur décimal (par défaut : \code{.}).
#' @param ... Autres paramètres de la fonction \code{read.csv}.
#'
#' @details
#' par defaul
#'
#'
#' @returns Un objet de type \code{data.frame}.
#' @export
#'
#' @examples
#' file_path <- system.file("extdata", "file.csv", package = "TBox")
#' file_path <- normalizePath(file_path, winslash = "/", mustWork = FALSE)
#'
#' df <- get_data(file_path, erase_zero = FALSE)
#'
get_data <- function(path, erase_zero = TRUE, sep = ";", dec = ".", ...) {
    path <- normalizePath(path, mustWork = TRUE)
    data_read <- read.csv(
        file = path,
        sep = sep,
        dec = dec,
        header = TRUE,
        encoding = "UTF-8",
        ...
    )
    if (erase_zero) {
        data_read[data_read == 0L] <- NA_real_
    }
    return(data_read)
}


#' @title Ecriture des fichiers de donnée
#'
#' @param data \code{data.frame}. Données à écrire dans un fichier csv.
#' @param path Chaîne de caractère. Chemin du fichier csv.
#'
#' @details
#' La fonction écrit les données dans un fichier csv avec les paramètres
#' suivants :
#'     - séparateur de colonne : \code{;}
#'     - séparateur décimal : \code{.}
#'     - pas de guillemets
#'     - pas de noms de lignes
#'     - les \code{NA} sont remplacés par une chaîne vide.
#'
#' @returns Chaîne de caractère. Chemin du fichier écrit.
#' @export
#'
#' @examples
#' new_path <- tempfile("new_file", fileext = ".csv")
#' write_data(data = mtcars, path = new_path)
#'
write_data <- function(data, path) {
    path <- normalizePath(path, mustWork = FALSE)
    write.table(
        x = data,
        file = path,
        quote = FALSE,
        sep = ";",
        row.names = FALSE,
        dec = ".",
        na = ""
    )
    return(invisible(path))
}
