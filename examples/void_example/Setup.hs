import Data.Monoid
import Distribution.Simple
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.BuildPaths (mkSharedLibName)
import Distribution.Simple.Setup (buildVerbosity, configVerbosity, fromFlag)
import Distribution.Simple.Utils (rawSystemExit)

main = defaultMainWithHooks simpleUserHooks
    { postBuild = \_ flags _ lbi -> do
        let verbosity = fromFlag (buildVerbosity flags)
        buildJavaSource verbosity
    }

buildJavaSource verbosity = do
    rawSystemExit verbosity "gradle" ["build"]
    -- We want a shadowjar for AWS just to be sure that we have the appropriate
    -- dependencies.
    rawSystemExit verbosity "gradle" ["shadowjar"]
    error
