module Pages.Files.Model exposing (..)

import Http

type Msg
  = Init
  | InitResponse (Result Http.Error FileList)
  | FilterChange String
  | EnterDirectory String
  | DirectoryResponse (Result Http.Error FileList)
  | GetDownloadLink String
  | DownloadLinkResponse (Result Http.Error FileList)

type alias FileList = List FileEntry

type Children = Children (List FileEntry)

type alias FileEntry =
  { id : String
  , name : String
  , isDirectory : Bool
  }

type alias Model =
  { isLoading : Bool
  , entries : List FileEntry
  , filter : String
  , path : List (Int, String)
  }

initialModel : Model
initialModel =
  { isLoading = True
  , entries = []
  , filter = ""
  , path = []
  }
