module Doc where

import System.FilePath
import Data.List.Extra


-- |Vendor of a docset
data Vendor
  = DevDocs -- ^Docset provided by devdocs.io
  | Hoogle  -- ^Docset provided by an archive, from which a Hoogle database can be generated
  deriving (Show, Eq)


-- |To which language or library does this entry belong
newtype Collection =
  Collection {getCollection :: String}
  deriving (Eq, Ord)


-- |Version of the collection
--
-- For 'DevDocs', this is the version of the language or the library, e.g. the @3.6.4@ as in @Python 3.6.4@, or the @1.13.0@ as in @NumPy 1.13.0@.
--
-- For 'Hoogle', this is the @NAME@ parameter in the @doc-browser --install-hoogle@ command
newtype Version =
  Version {getVersion :: String}
  deriving (Eq, Ord)


-- TODO @incomplete: handle multiple occurrences of "=="
combineCollectionVersion :: Collection -> Version -> String
combineCollectionVersion (Collection c) (Version v) =
  c ++ "==" ++ v

-- TODO @incomplete: this should be a Maybe
breakCollectionVersion :: String -> (Collection, Version)
breakCollectionVersion cv =
  let (c, v') = breakOn "==" . takeFileName $ cv
      v = drop (length "==") v'
  in (Collection c, Version v)
