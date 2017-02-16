module Pages.Files.Model exposing (Msg(..), Model, initialModel)

import Http

type Msg
  = Init
  | InitResponse (Result Http.Error Response)
  | EnterDirectory Int
  | DirectoryResponse (Result Http.Error Response)
  | GetDownloadLink Int
  | DownloadLinkResponse (Result Http.Error Response)

type alias Response = List FileEntry

type alias FileEntry =
    { id : Int
    , name : String
    , isDirectory : Bool
    -- , children : List 
    }

type alias Model =
  { entries : List FileEntry
  , path : List (Int, String)
  }

initialModel : Model
initialModel =
  { entries = []
  , path = []
  } 
