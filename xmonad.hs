import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run
import XMonad.Util.EZConfig
import System.IO
import Data.List

import XMonad.Config.Gnome
import XMonad.Actions.SimpleDate

import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.FloatKeys

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Layout.IndependentScreens -- provides countScreens function
-- see http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CycleWS.html

-- for fullscreen.
-- ref: https://wiki.archlinux.org/index.php/Xmonad#Chromium.2FChrome_will_not_go_fullscreen
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

import XMonad.Hooks.SetWMName

-- check xmodmap -pm to see mod key mapping


devMode = False
myFocusedBorderColor = if devMode == True then "green" else "red"

main = do
    xmonad $ gnomeConfig
        { terminal = "terminator" -- terminal = "gnome-terminal" 
        , borderWidth = 2
        , modMask = myModMask
        --, focusedBorderColor = "red"
        , focusedBorderColor = myFocusedBorderColor
        -- , manageHook = manageDocks -- <+> manageHook gnomeConfig
        -- , layoutHook = avoidStruts $ layoutHook gnomeConfig
        , layoutHook = myLayout -- avoidStruts $ layoutHook defaultConfig
        , manageHook = myManageHook <+> manageHook gnomeConfig
        , workspaces = myWorkspaces
        -- , logHook = myLogHook

        , handleEventHook = fullscreenEventHook

        , startupHook = setWMName "LG3D"
        } `additionalKeys` myKeys

-- myLogHook :: X ()
-- myLogHook = fadeInactiveLogHook fadeAmount
--     where fadeAmount = 1

myLayout = tiled 
       ||| Mirror tiled 
       ||| ThreeCol 1 (3/100) (1/3) -- ThreeColMid 1 (3/100) (1/3) 
       ||| simpleTabbed -- ||| Full ||| ThreeCol 1 (3/100) (1/2)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

myModMask = mod3Mask
myWorkspaces = [ "1"
               , "2:web"
               , "3"
               , "4:mail"
               , "5"
               , "6:code1"
               , "7"
               , "8:read"
               , "9"
               , "0"
               , "f9"
               , "fa"
               , "fb"
               , "fc"
               ]
role = stringProperty "WM_WINDOW_ROLE"

-- use `xprop` to find out the window class name
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Pidgin" --> doFloat
    , className =? "Skype" --> doFloat
    , className =? "Shutter" --> doFloat
    , className =? "SpiderOak" --> doFloat
    , className =? "CrashPlan" --> doFloat
    , className =? "Tk" --> doFloat
    -- , className =? "Display" --> doFloat
    , fmap ("awt-X11" `isInfixOf`) title --> doFloat -- java awt windows
    , title     =? "Set Zoom" --> doFloat -- xournal's zoom box
    , title     =? "Run Application" --> doFloat
    , fmap ("Properties" `isInfixOf`) title --> doFloat
    , className =? "Gimp-2.6" --> doFloat
    -- , className =? "Chromium-browser" --> doShift "2:web"
    , className =? "Thunderbird" --> doShift "4:mail"
    , className =? "Calibre" --> doShift "8:read"
    , className =? "Kalarm" --> doShift "0"
    , className =? "Xournalpp" --> doShift "8:read"
    -- , ( role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> (ask >>= doF . W.sink)
    , className =? "Emacs" --> doFloat
    , className =? "Toplevel" --> doFloat
    -- Firefox download window
    , fmap (isInfixOf "Downloads") title --> doFloat
    -- doesn't work, because title is initialized after emacs window appears
    -- , fmap (isInfixOf "Speedbar") title --> doFloat
    --
    -- for R plots
    , className =? "" --> doFloat
    -- , fmap ("R Graphics" `isInfixOf`) title --> doFloat
    
    -- for flash video
    -- ref: http://comments.gmane.org/gmane.comp.lang.haskell.xmonad/10119
    -- , isFullscreen --> doF W.focusDown <+> doFullFloat

    ]

myKeys = [] ++
         [ ((mod4Mask, xK_space    ), unsafeSpawn "$HOME/.config/thinkpad/dzen/popup_calendar.sh")] ++

         -- application shortcuts
         [ ((mod4Mask, xK_F9      ), unsafeSpawn "emacsclient -c -e '(switch-to-buffer (dolist (buf (buffer-list)) (if (or (equal (get-buffer \"*scratch*\") buf) (equal (get-buffer \" *Minibuf-1*\") buf)) nil  (return buf))))'")] ++
         [ ((mod4Mask, xK_Return  ), unsafeSpawn "$HOME/.config/thinkpad/emacs-remember")] ++
         [ ((mod4Mask .|. mod1Mask, xK_x      ), unsafeSpawn "xournal")] ++
         [ ((mod4Mask .|. mod1Mask, xK_h      ), unsafeSpawn "nautilus")] ++

         -- cycle windows, emulate old-style alt-tab
         [ ((mod1Mask,               xK_Tab   ), windows W.focusDown)
         , ((mod1Mask .|. shiftMask, xK_Tab   ), windows W.focusUp)
         ] ++
         -- a basic CycleWS setup
         [ ((myModMask,               xK_Down),  nextWS)
         , ((myModMask,               xK_Up),    prevWS)
         , ((myModMask .|. shiftMask, xK_Down),  shiftToNext)
         , ((myModMask .|. shiftMask, xK_Up),    shiftToPrev)
         , ((myModMask,               xK_Right), nextScreen)
         , ((myModMask,               xK_Left),  prevScreen)
         , ((myModMask .|. shiftMask, xK_Right), shiftNextScreen)
         , ((myModMask .|. shiftMask, xK_Left),  shiftPrevScreen)
         , ((myModMask,               xK_z),     toggleWS)
         ] ++
         -- FloatKeys
         [ ((myModMask,               xK_f   ), withFocused (keysMoveWindow (25, 0)))
         , ((myModMask,               xK_s   ), withFocused (keysMoveWindow (-25, 0)))
         , ((myModMask,               xK_d   ), withFocused (keysMoveWindow (0, -25)))
         , ((myModMask,               xK_c   ), withFocused (keysMoveWindow (0, 25)))
         , ((myModMask .|. shiftMask, xK_f   ), withFocused (keysMoveWindow (5, 0)))
         , ((myModMask .|. shiftMask, xK_s   ), withFocused (keysMoveWindow (-5, 0)))
         , ((myModMask .|. shiftMask, xK_d   ), withFocused (keysMoveWindow (0, -5)))
         , ((myModMask .|. shiftMask, xK_c   ), withFocused (keysMoveWindow (0, 5)))

         -- to fix the overwritten default of Mod+Shift+c
         , ((mod1Mask               , xK_F4   ), kill)

         , ((myModMask .|. controlMask, xK_f   ), withFocused (keysResizeWindow (20, 0)  (0, 0)))
         , ((myModMask .|. controlMask, xK_s   ), withFocused (keysResizeWindow (-10, 0) (0, 0)))
         , ((myModMask .|. controlMask, xK_d   ), withFocused (keysResizeWindow (0, -10)  (0, 0)))
         , ((myModMask .|. controlMask, xK_c   ), withFocused (keysResizeWindow (0, 20) (0, 0)))
         ] ++
         [((m .|. mod3Mask, k), windows $ f i)
              | (i, k) <- zip myWorkspaces ([xK_1 .. xK_9] ++ [xK_0] ++ [xK_F9, xK_F10, xK_F11, xK_F12])
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
         ] ++
         -- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Screens_are_in_wrong_order
         [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f)) -- Replace 'mod1Mask' with your mod key of choice.
             | (key, sc) <- zip [xK_w, xK_e] [1,0] -- was [0..] *** change to match your screen order ***
             , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
