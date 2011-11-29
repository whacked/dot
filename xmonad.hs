import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig
import System.IO

import XMonad.Util.EZConfig
import XMonad.Config.Gnome
import XMonad.Actions.SimpleDate
import XMonad.Layout.ThreeColumns

import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows

-- check xmodmap -pm to see mod key mapping

main = do
    xmonad $ gnomeConfig
        { terminal = "gnome-terminal" 
        , borderWidth = 1
        , modMask = myModMask
        -- , focusedBorderColor = "red"
        -- , manageHook = manageDocks -- <+> manageHook gnomeConfig
        -- , layoutHook = avoidStruts $ layoutHook gnomeConfig
        , manageHook = myManageHook <+> manageHook gnomeConfig
        , workspaces = myWorkspaces
        } `additionalKeys` myKeys

myModMask = mod3Mask
myWorkspaces = ["1",
                "2:web",
                "3",
                "4:mail",
                "5",
                "6:code1",
                "7",
                "8:read",
                "9"]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Pidgin" --> doFloat
    , className =? "Skype" --> doFloat
    , className =? "SpiderOak" --> doFloat
    , className =? "CrashPlan" --> doFloat
    -- , className =? "chromium-browser" --> doShift "2:web"
    , className =? "ThunderBird" --> doShift "4:mail"
    , className =? "Calibre" --> doShift "8:read"
    ]

myKeys = [] ++
         [ ((mod4Mask, xK_space    ), unsafeSpawn "$HOME/.config/thinkpad/dzen/popup_calendar.sh")] ++
         -- cycle windows, emulate old-style alt-tab
         [ ((mod1Mask,               xK_Tab   ), windows W.focusDown)
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
         [((m .|. mod3Mask, k), windows $ f i)
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
