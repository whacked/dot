import XMonad
import XMonad.Util.EZConfig
import XMonad.Config.Gnome

-- check xmodmap -pm to see mod key mapping

main = do
    xmonad $ gnomeConfig
      { terminal = "gnome-terminal" 
      , borderWidth = 1
      , modMask = mod3Mask
      , focusedBorderColor = "red"
      }
