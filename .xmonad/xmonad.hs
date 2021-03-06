
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

import qualified XMonad.StackSet as W

-- Data
import Data.Maybe (fromJust)
import qualified Data.Map        as M

import XMonad.Util.Run

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

-- modMask1 -> left alt
-- modMask3 -> right alt
-- modMask4 -> Windows Key 

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
    , ((modm,               xK_a     ), spawn "rofi -show drun")     

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_Delete     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
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

myLayout = (grid ||| full ||| tabs ||| tall ||| spirals ||| threeCol ||| threeRow  ||| floats )
 
  where
     tall           = renamed [Replace "tall"]
                      $ avoidStruts
                      $ limitWindows 5
                      $ mySpacing 8
                      $ ResizableTall 1 (3/100) (1/2) []
     
     -- Bug Issue because of the new 17.0 update
     -- magnify        = renamed [Replace "magnify"]
     --                 $ avoidStruts
     --                 $ limitWindows 5
     --                 $ mySpacing 8
     --                 $ Mag.magnifier
     --                 $ ResizableTall 1 (3/100) (1/2) []
     
     full           = renamed [Replace "full"]
                      $ smartBorders
                      $ Full
     floats         = renamed [Replace "floats"]
                      $ avoidStruts
                      $ smartBorders
                      $ simplestFloat
     grid           = renamed [Replace "grid"]
                      $ avoidStruts
                      $ limitWindows 9
                      $ mySpacing 8
                      $ Grid (16/10)     
     spirals        = renamed [Replace "spirals"]
                      $ avoidStruts
                      $ smartBorders
                      $ limitWindows 9
                      $ mySpacing 8
                      $ spiral (6/7)
     threeCol       = renamed [Replace "threeCol"]
                      $ avoidStruts
                      $ smartBorders
                      $ limitWindows 4
                      $ mySpacing 8
                      $ ThreeCol 1 (3/100) (1/2)
     threeRow       = renamed [Replace "threeRow"]
                      $ avoidStruts
                      $ smartBorders
                      $ limitWindows 7
                      $ mySpacing 8 
                      $ Mirror
                      $ ThreeCol 1 (3/100) (1/2)
     tabs           = renamed [Replace "tabs"]
                      $ avoidStruts
                      $ mySpacing 8
                      $ tabbed shrinkText tabsConfig 
     
     -- tallAccordion  = renamed [Replace "tallAccordion"]
     --                 $ avoidStruts
     --                 $ mySpacing 4
     --                 $ Accordion
     -- wideAccordion  = renamed [Replace "wideAccordion"]
     --                 $ avoidStruts
     --                 $ mySpacing 4
     --                 $ Mirror Accordion

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
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

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

myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------

-- MAIN

-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.

main = do

    xmproc0 <- spawnPipe "xmobar -x 0 /home/papzi/.config/xmobar/xmobarrc0"  

    xmproc1 <- spawnPipe "xmobar -x 1 /home/papzi/.config/xmobar/xmobarrc1"

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
           ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
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
    
    -- xmproc2 <- spawnPipe "xmobar -x 1 /home/papzi/.config/xmobar/xmobarrc1-border"









-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
