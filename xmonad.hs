import XMonad
-- import XMonad.Config.Gnome
-- import XMonad.Config.Xfce
import Data.Typeable
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run
import XMonad.Util.EZConfig
import System.IO
import Data.List
import Data.Maybe

import XMonad.Actions.SimpleDate

import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.FloatKeys
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.SwapWorkspaces

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Layout.IndependentScreens -- provides countScreens function
-- see http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CycleWS.html

-- for fullscreen.
-- ref: https://wiki.archlinux.org/index.php/Xmonad#Chromium.2FChrome_will_not_go_fullscreen
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

import XMonad.Hooks.SetWMName
import XMonad.Hooks.Place -- for placing floating windows
import XMonad.Layout.ShowWName

-- check xmodmap -pm to see mod key mapping

devMode = False
myFocusedBorderColor = if devMode == True then "green" else "red"

-- see Xmodmap for rebinding
myModMask = mod3Mask

-- was [0..] *** change to match your screen order ***
-- this is used by screenWorkspace below, so the type is ScreenId
myScreenOrderMapping :: [ScreenId]
myScreenOrderMapping = [0,2,1]

main = do
    -- xmonad $ xfceConfig
    -- xmonad $ gnomeConfig
    xmonad $ defaultConfig
        { terminal = "terminator"
        , borderWidth = 1
        , modMask = myModMask
        --, focusedBorderColor = "red"
        , focusedBorderColor = myFocusedBorderColor

        -- , manageHook = manageDocks -- <+> manageHook gnomeConfig
        -- , layoutHook = avoidStruts $ layoutHook gnomeConfig
        
        , layoutHook = showWName myLayout -- avoidStruts $ layoutHook defaultConfig
        , manageHook = myManageHook -- <+> manageHook xfceConfig
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
       ||| ThreeCol 1 (3/100) (1/3)  -- ThreeColMid 1 (3/100) (1/3)
       ||| simpleTabbed -- ||| Full ||| ThreeCol 1 (3/100) (1/2)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

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

myWorkspaceKeys = ([xK_1 .. xK_9] ++ [xK_0] ++ [xK_F9, xK_F10, xK_F11, xK_F12])

role = stringProperty "WM_WINDOW_ROLE"

-- https://mail.haskell.org/pipermail/xmonad/2009-September/008497.html
-- note that the referenced swapNextScreen / swapPrevScreen does not allow targeting arbitrary screens
swapScreens = do
   screen <- gets (listToMaybe . W.visible . windowset)
   whenJust screen $ windows . W.greedyView . W.tag . W.workspace

-- use `xprop` to find out the window class name
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Pidgin" --> doFloat
    , className =? "Skype" --> doFloat
    , className =? "Shutter" --> doFloat
    , className =? "Tk" --> doFloat
    , className =? "Conky" --> doIgnore

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
    , className =? "Calibre-gui" --> doShift "fa"
    -- , ( role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> (ask >>= doF . W.sink)
    , className =? "Toplevel" --> doFloat
    -- Firefox download window
    , fmap (isInfixOf "Downloads") title --> doFloat
    -- doesn't work, because title is initialized after emacs window appears
    -- , fmap (isInfixOf "Speedbar") title --> doFloat
    --
    -- for R plots
    -- , className =? "" --> doFloat
    -- , fmap ("R Graphics" `isInfixOf`) title --> doFloat
    --
    -- gloobus preview
    , className =? "Gloobus-preview" --> doFloat
    
    -- for flash video
    -- ref: http://comments.gmane.org/gmane.comp.lang.haskell.xmonad/10119
    -- , isFullscreen --> doF W.focusDown <+> doFullFloat
    , className =? "flashplayerdebugger" --> doShift "3"
    , className =? "Flashplayerdebugger" --> doShift "3"

    -- gimp
    , title =? "New Layer" --> doFloat
    , title =? "Change Foreground Color" --> doFloat

    , resource =? "Do" --> doFloat

    -- for imagemagick `display`
    , className =? "Display.im6" --> doCenterFloat

    -- firefox extension
    , fmap (isInfixOf "Tree Style Tab") title --> doFloat
    ]

-- ref https://github.com/iamjamestl/dotfiles/blob/3919540264c4be6298f9a4354f36ccc11fded226/.xmonad/xmonad.hs.erb#L191
physicalScreens :: X [Maybe ScreenId]
physicalScreens = withWindowSet $ \windowSet -> do
    let numScreens = length $ W.screens windowSet
    mapM (\s -> getScreen def (P s)) [0..numScreens]

getPhysicalScreen :: ScreenId -> X (Maybe PhysicalScreen)
getPhysicalScreen sid = do
    pscreens <- physicalScreens
    return $ (Just sid) `elemIndex` pscreens >>= \s -> Just (P s)

toggleConky :: X ()
toggleConky = do
    withWindowSet $ \windowSet -> do
        let sid = W.screen (W.current windowSet)
        pscreen <- getPhysicalScreen sid
        unsafeSpawn (
            "if pgrep conky; then pkill conky; else conky -m "
            ++ (show (toInteger (case pscreen of
                                     Just (P s) -> myScreenOrderMapping!!s
                                     otherwise  -> 0)))
            ++ " -c $HOME/dot/conkyrc; fi")

myKeys = [] ++
         -- [ ((myModMask, xK_p       ), unsafeSpawn "rofi -show run -modi run")] ++
         [ ((mod4Mask, xK_space    ), toggleConky)] ++

         -- application shortcuts
         [ ((mod4Mask, xK_F9      ), unsafeSpawn "emacsclient -c -e '(switch-to-buffer (dolist (buf (buffer-list)) (if (or (equal (get-buffer \"*scratch*\") buf) (equal (get-buffer \" *Minibuf-1*\") buf)) nil  (return buf))))'")] ++
         [ ((mod4Mask, xK_Return  ), unsafeSpawn "$HOME/.config/thinkpad/emacs-remember")] ++
         [ ((mod4Mask .|. mod1Mask, xK_x      ), unsafeSpawn "xournal")] ++
         [ ((mod4Mask .|. mod1Mask, xK_h      ), unsafeSpawn "nemo")] ++

         [ ((mod4Mask             , xK_p      ), unsafeSpawn "gedit")] ++

         -- cycle windows, emulate old-style alt-tab
         [ ((mod1Mask,               xK_Tab   ), windows W.focusDown)
         , ((mod1Mask .|. shiftMask, xK_Tab   ), windows W.focusUp)
         ] ++

         -- [ ((myModMask,               xK_p),  unsafeSpawn "gnome-do") ] ++

         -- a basic CycleWS setup
         [ ((myModMask,               xK_Down ), nextWS)
         , ((myModMask,               xK_Up   ), prevWS)
         , ((myModMask .|. shiftMask, xK_Down ), shiftToNext)
         , ((myModMask .|. shiftMask, xK_Up   ), shiftToPrev)
         , ((myModMask,               xK_Right), nextScreen)
         , ((myModMask,               xK_Left ), prevScreen)
         , ((myModMask .|. shiftMask, xK_Right), shiftNextScreen)
         , ((myModMask .|. shiftMask, xK_Left ), shiftPrevScreen)
         , ((myModMask,               xK_z    ), toggleWS)

         , ((myModMask .|. controlMask, xK_Left  ), swapPrevScreen)
         , ((myModMask .|. controlMask, xK_Right ), swapNextScreen)
         , ((myModMask .|. controlMask, xK_z  ), swapScreens)
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

         , ((myModMask .|. controlMask, xK_f   ), withFocused (keysResizeWindow ( 20,   0) (0, 0)))
         , ((myModMask .|. controlMask, xK_s   ), withFocused (keysResizeWindow (-10,   0) (0, 0)))
         , ((myModMask .|. controlMask, xK_d   ), withFocused (keysResizeWindow (  0, -10) (0, 0)))
         , ((myModMask .|. controlMask, xK_c   ), withFocused (keysResizeWindow (  0,  20) (0, 0)))
         ] ++

         [((m .|. mod3Mask, k), windows $ f i)
              | (i, k) <- zip myWorkspaces myWorkspaceKeys
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
         ] ++

         -- swaps workspace LABELs
         -- [((myModMask .|. controlMask, k), windows $ swapWorkspaces i) | (i, k) <- zip myWorkspaces myWorkspaceKeys ] ++
         -- [((m .|. mod3Mask .|. controlMask, k), windows $ f i)
         --      | (i, k) <- zip myWorkspaces myWorkspaceKeys
         --      , (f, m) <- [(W.view, 0), (W.shift, shiftMask .|. controlMask)]
         -- ] ++
         --

         -- -- Cycle recent (not visible) workspaces, tab is next, escape previous in history
         -- , let options w     = map (W.greedyView `flip` w)   (hiddenTags w)
         --   in ("M-<Tab>" , cycleWindowSets options [xK_Super_L] xK_Tab xK_Escape)

         -- -- https://mail.haskell.org/pipermail/xmonad/2009-August/008462.html
         -- -- Cycle through visible screens, a is next, s previous
         -- , let options w     = map (W.view `flip` w)         (visibleTags w)
         --   in ("M-a"     , cycleWindowSets options [xK_Super_L] xK_a xK_s)

         -- Swap visible workspaces on current screen, s is next, d previous
         -- , let options w     = map (W.greedyView `flip` w)   (visibleTags w)
         --   in ("M-s"     , cycleWindowSets options [xK_Super_L] xK_s xK_d)

         -- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#Screens_are_in_wrong_order
         [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f)) -- Replace 'mod1Mask' with your mod key of choice.
             | (key, sc) <- zip [xK_w, xK_e, xK_r] myScreenOrderMapping
             , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
