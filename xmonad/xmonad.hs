-- Modified by Papzi

------------------------------------------------------------------------

-- IMPORTS

import XMonad
import Data.Monoid
import System.Exit

-- Layout

import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.LimitWindows
import XMonad.Layout.Renamed

-- Different Layout Plugins
import XMonad.Layout.ResizableTile
import qualified XMonad.Layout.Magnifier as Mag
import XMonad.Layout.SimplestFloat
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion

-- Hooks

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WindowSwallowing

import qualified XMonad.StackSet as W

-- Data
import Data.Maybe (fromJust)
import qualified Data.Map        as M

-- Utilities
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------

myFont :: String
myFont = "xft:Mononoki Nerd Font:regular:size=9:antialias=true:hinting=true"

------------------------------------------------------------------------

-- TERMINAL

myTerminal      = "alacritty"

------------------------------------------------------------------------

-- MOUSE POINTER

-- Whether focus follows the mouse pointer.

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window

myClickJustFocuses :: Bool
myClickJustFocuses = False

------------------------------------------------------------------------

-- WINDOW BORDER WIDTH

-- Width of the window border in pixels.

myBorderWidth = 2

------------------------------------------------------------------------

-- MOD MASK

-- mod1Mask -> left alt
-- mod3Mask -> right alt
-- mod4Mask -> Windows Key 

myModMask       = mod4Mask

------------------------------------------------------------------------

-- WORKSPACES

-- Example: 
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]

myWorkspaces    = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- myWorkspaces = [" TERM ", " DEV:1 ", " DEV:2 ", " DEV:3 ", " WEB:1 ", " WEB:2 ", " MEDIA ", " STUDIO ", " MISC "]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

-- Note: Prereq -> Download xdotool 
clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectively.

myNormalBorderColor  = "#2e3440"
myFocusedBorderColor = "#b1c8cd"

------------------------------------------------------------------------

-- KEY BINDINGS

-- Key bindings. Add, modify or remove key bindings here.

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    
    -- launch rofi
    , ((modm, xK_a ), spawn "rofi -show drun")

    -- brightness brillo | I change the permission of brillo to work without sudo by entering "sudo chmod u+s /usr/bin/brillo"
    , ((modm .|. shiftMask, xK_Up ), spawn "brightnessctrl up")
    , ((modm .|. shiftMask, xK_Down ), spawn "brightnessctrl down")

    -- volume control amixer
    , ((modm .|. controlMask, xK_Up ), spawn "volumectrl up")
    , ((modm .|. controlMask, xK_Down ), spawn "volumectrl down")

    -- Take screenshot	
    --, ((modm .|. controlMask, xK_a ), spawn "screenshot app")
    --, ((modm .|. controlMask, xK_s ), spawn "screenshot single")
    --, ((modm .|. controlMask, xK_d ), spawn "screenshot dual")
    , ((modm .|. shiftMask, xK_s ), spawn "screenshot free")

    -- Rofi Power Menu  
    , ((modm .|. mod1Mask, xK_4 ), spawn "rofi -show power-menu -modi power-menu:rofi-power-menu")

    -- launch dmenu
    , ((modm, xK_p ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p ), spawn "gmrun")

    -- close focused window
    --, ((modm .|. shiftMask, xK_Delete ), kill)
    , ((modm .|. shiftMask, xK_c ), kill)

     -- Rotate through the available layout algorithms
    , ((modm, xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm, xK_n ), refresh)

    -- Move focus to the next window
    , ((modm, xK_Tab ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm, xK_j ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm, xK_k ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm, xK_m ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm, xK_Return ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm, xK_h ), sendMessage Shrink)

    -- Expand the master area
    , ((modm, xK_l ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm, xK_t ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm, xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. controlMask, xK_space ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm, xK_q ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------

-- MOUSE BINDINGS

-- Mouse bindings: default actions bound to mouse events

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------

-- LAYOUTS

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = ( tall ||| grid ||| full ||| tabs ||| spirals ||| threeCol ||| floats )
 
  where
     tall           = renamed [Replace "tall"]
                      $ avoidStruts
                      $ limitWindows 5
                      $ mySpacing 4
                      $ ResizableTall 1 (3/100) (1/2) []
     
     -- Bug Issue because of the new 17.0 update
     -- magnify        = renamed [Replace "magnify"]
     --                  $ avoidStruts
     --                  $ limitWindows 5
     --                  $ mySpacing 4
     --                  $ Mag.magnifier
     --                  $ ResizableTall 1 (3/100) (1/2) []
     -- 
     full           = renamed [Replace "full"]
                      $ noBorders
                      $ Full
     floats         = renamed [Replace "floats"]
                      $ avoidStruts
                      $ smartBorders
                      $ simplestFloat
     grid           = renamed [Replace "grid"]
                      $ avoidStruts
                      $ limitWindows 9
                      $ mySpacing 4
                      $ Grid (16/10)     
     spirals        = renamed [Replace "spirals"]
                      $ avoidStruts
                      $ smartBorders
                      $ limitWindows 9
                      $ mySpacing 4
                      $ spiral (6/7)
     threeCol       = renamed [Replace "threeCol"]
                      $ avoidStruts
                      $ smartBorders
                      $ limitWindows 4
                      $ mySpacing 4
                      $ ThreeCol 1 (3/100) (1/2)
     -- threeRow       = renamed [Replace "threeRow"]
     --                  $ avoidStruts
     --                  $ smartBorders
     --                  $ limitWindows 7
     --                  $ mySpacing 6 
     --                  $ Mirror
     --                  $ ThreeCol 1 (3/100) (1/2)
     tabs           = renamed [Replace "tabs"]
                      $ avoidStruts
                      $ noBorders
                      $ tabbed shrinkText tabsConfig 
     
     -- tallAccordion  = renamed [Replace "tallAccordion"]
     --                  $ avoidStruts
     --                  $ mySpacing 4
     --                  $ Accordion
     -- wideAccordion  = renamed [Replace "wideAccordion"]
     --                  $ avoidStruts
     --                  $ mySpacing 4
     --                  $ Mirror Accordion

tabsConfig = def { fontName            = myFont
                 , activeColor         = "#b1c8cd"
                 , inactiveColor       = "#2e3440"
                 , activeBorderColor   = "#2e3440"
                 , inactiveBorderColor = "#b1c8cd"
                 , activeTextColor     = "#2e3440"
                 , inactiveTextColor   = "#b1c8cd"
                 }

------------------------------------------------------------------------

-- MANAGE HOOKS

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.

-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.

myManageHook = composeAll
    [className =? "discord"        --> doShift (myWorkspaces !! 8),
    className =? "PacketTracer"    --> doCenterFloat,
    className =? "gimp-2.10"       --> doFloat,
    className =? "vmware"          --> doFloat]

------------------------------------------------------------------------

-- EVENT HOOK

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

myEventHook = mempty

------------------------------------------------------------------------
-- STATUS BAR / LOG HOOK

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

-- myLogHook = return ()

------------------------------------------------------------------------

-- START UP PROCCESSES  

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.

-- By default, do nothing.

myStartupHook = do
   spawnOnce "picom -b"
   spawnOnce "nitrogen --restore &"
   spawnOnce "export _JAVA_AWT_WM_NONPARENTING=1"
   spawnOnce "xsetroot -cursor_name left_ptr &" 
   setWMName "LG3D"

------------------------------------------------------------------------

-- MAIN

-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.

main = do

    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"  
    -- xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0-nobg"  

    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1"
    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1-nobg"

    xmonad $ docks $ def {  
  
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,

        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook,
        logHook = dynamicLogWithPP xmobarPP

        { 
           ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc0 x
           ,ppCurrent = xmobarColor "#b1c8cd" "" . wrap "[" "]" 
           ,ppVisible = xmobarColor "#b1c8cd" "" . clickable
           ,ppHidden  = xmobarColor "#b1c8cd" "" . wrap "*" "" . clickable
           ,ppHiddenNoWindows  = xmobarColor "#7F7F7F" "" . clickable
           ,ppTitle = xmobarColor "#b1c8cd" "" . shorten 60
           ,ppSep = "<fc=#b1c8cd> <fn=1>|</fn> </fc>"
           ,ppUrgent = xmobarColor "#900000" "" . wrap "[" "]"
           ,ppOrder = \(ws : l : t : ex) -> [ws, l, t]
        }
         
    }

