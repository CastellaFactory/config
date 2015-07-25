----------------------------------------------------------------------
-- XMonad config
----------------------------------------------------------------------

{- Import {{{1 -}
-- import System.IO
-- import XMonad.Layout
-- import XMonad.Util.Run
import Control.Arrow (first)
import Control.Monad (liftM2)
import Data.Char (isSpace)
import Data.Monoid (All, Endo)
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isDialog, doCenterFloat)
import XMonad.Hooks.SetWMName
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints (layoutHints, hintsEventHook)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig (additionalKeys)
import qualified Data.Map as M (Map, fromList)
import qualified XMonad.Layout.Fullscreen as F (fullscreenEventHook, fullscreenManageHook)
import qualified XMonad.Layout.Magnifier as Mag
import qualified XMonad.StackSet as W
{- 1}}} -}

{- mySetting {{{1 -}
myTerminal          :: String
myTerminal          = "urxvt"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myClickJustFocuses  :: Bool
myClickJustFocuses  = False
myBorderWidth :: Dimension
myBorderWidth       = 1
myModMask           :: KeyMask
myModMask           = mod4Mask
myWorkspaces        :: [String]
myWorkspaces        = ["1:General","2:Web","3:Code","4:Skype","5:Reading","6:Media","7:Office","8","9"]
myNormalBorderColor :: String
myNormalBorderColor = "#99ccff"
myFocuseBorderColor :: String
myFocuseBorderColor = "#0033dd"

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig {
                font      = "xft:SourceHanCodeJP:size=11:bold:antialial=true"
                , height  = 24
                , bgColor = "black"
                , fgColor = "white"
                , promptKeymap = myXPKeymap
                , historyFilter = deleteAllDuplicates
             }

myXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = myXPKeymap' isSpace

myXPKeymap' :: (Char -> Bool) -> M.Map (KeyMask,KeySym) (XP ())
myXPKeymap' p = M.fromList $
                map (first $ (,) controlMask) -- control + <key>
                [ (xK_u, killBefore)          --kill line backwards
                , (xK_k, killAfter)           -- kill line fowards
                , (xK_a, startOfLine)         --move to the beginning of the line
                , (xK_e, endOfLine)           -- move to the end of the line
                , (xK_d, deleteString Next)   -- delete a character foward
                , (xK_h, deleteString Prev)   -- delete a character backward
                , (xK_b, moveCursor Prev)     -- move cursor forward
                , (xK_f, moveCursor Next)     -- move cursor backward
                , (xK_w, killWord' p Prev)    -- kill the previous word
                , (xK_y, pasteString)
                , (xK_g, quit)
                , (xK_c, quit)
                ]
                ++
                map (first $ (,) mod1Mask) -- meta key + <key>
                [ (xK_BackSpace, killWord' p Prev)
                , (xK_f, moveWord' p Next) -- move a word forward
                , (xK_b, moveWord' p Prev) -- move a word backward
                , (xK_d, killWord' p Next) -- kill the next word
                , (xK_n, moveHistory W.focusUp')
                , (xK_p, moveHistory W.focusDown')
                ]
                ++
                map (first $ (,) 0) -- <key>
                [ (xK_Return, setSuccess True >> setDone True)
                , (xK_KP_Enter, setSuccess True >> setDone True)
                , (xK_BackSpace, deleteString Prev)
                , (xK_Delete, deleteString Next)
                , (xK_Left, moveCursor Prev)
                , (xK_Right, moveCursor Next)
                , (xK_Home, startOfLine)
                , (xK_End, endOfLine)
                , (xK_Down, moveHistory W.focusUp')
                , (xK_Up, moveHistory W.focusDown')
                , (xK_Escape, quit)
                ]
{- 1}}} -}

{- Key bindings {{{1 -}
-- Key bindings. Add, modify or remove key bindings here.
-- see also `additionalKeys` at bottom of this file.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

  [
    -- Launch a terminal(Win+Shift+RET)
    ((modm .|. shiftMask, xK_Return  ), spawn $ XMonad.terminal conf)

    -- Launch shellprompt(Win+p)
    , ((modm,               xK_p     ), shellPrompt myXPConfig)

    -- Launch gmrun(Win+Shift+p)
    --, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- Launch dmenu(Win+Ctrl+p)
    --, ((modm .|. controlMask, xK_p   ), spawn "dmenu_run -fn 'SourceHanCodeJP-11:bold'")

    -- Close focused window(Win+Shift+c)
    , ((modm .|. shiftMask, xK_c     ), kill)

    -- Rotate through the awailable layout algorithms(Win+Space)
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- Reset the layouts on the current workspace to default(Win+Shift+Space)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size(Win+n)
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window(Win+Tab)
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window(Win+j)
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window(Win+k)
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window(Win+m)
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window(Win+RET)
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window(Win+Shift+j)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window(Win+Shift+k)
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area(Win+h)
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area(Win+l)
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling(Win+t)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area(Win+,)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area(Win+.)
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad(Win+Shift+q)
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad(Win+q)
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
  ]

  ++

--
-- mod-[1..9], Switch to workspace N
-- mod-shift-[1..9], Move client to workspace N
--
  [
    ((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]

  ++

--
-- mod-{w,v,z}, Switch to physical/Xinerama screens 1, 2, or 3
-- mod-shift-{w,v,z}, Move client to screen 1, 2, or 3
--
  [
    ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_v, xK_z] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

{- 1}}} -}

{- Mouse bindings {{{1 -}
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig t -> M.Map (KeyMask, Button) (Window -> X())
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList

-- mod-button1, Set the window to floating mode and move by dragging
  [
  ((modm, button1), \w -> focus w >> mouseMoveWindow w
                          >> windows W.shiftMaster)

-- mod-button2, Raise the window to the top of the stack
  , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

-- mod-button3, Set the window to floating mode and resize by dragging
  , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                            >> windows W.shiftMaster)

-- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

{- 1}}} -}

{- Layouts {{{1 -}
myLayoutHook = layoutHints
           $ avoidStruts
           $ smartBorders . mkToggle (FULL ?? EOT)
           $ Mag.magnifiercz 1.3
           $ myLayout

myLayout = Tall 1 (3/100) (1/2) ||| Grid

{- 1}}} -}

{- Window rules {{{1 -}
myManageHook :: Query (Endo WindowSet)
myManageHook = manageDocks <+> F.fullscreenManageHook
               <+> composeAll [
               isDialog                                               --> doCenterFloat
               , className =? "MPlayer"                               --> doFloat
               , className =? "Smplayer"                              --> doFloat
               , className =? "Kmix"                                  --> doFloat
               , className =? "Firefox"                               --> viewShift "2:Web"
               , className =? "Thunderbird"                           --> viewShift "2:Web"
               , className =? "Chromium-browser"                      --> viewShift "2:Web"
               --             , className =? "Gvim"                 --> viewShift "3:Code"
               --             , className =? "Emacs"                --> viewShift "3:Code"
               , className =? "Skype"                                 --> doShift "4:Skype"
               , className =? "Skype"                                 --> doFloat
               , className =? "Calibre-gui"                           --> viewShift "5:Reading"
               , className =? "Calibre-ebook-viewer"                  --> viewShift "5:Reading"
               , className =? "Calibre-ebook-viewer"                  --> doFloat
               , className =? "Audacious"                             --> doShift "6:Media"
               , className =? "Audacious"                             --> doFloat
               , resource  =? "desktop_window"                        --> doIgnore
               , resource  =? "kdesktop"                              --> doIgnore
               ]
  where viewShift = doF . liftM2 (.) W.view W.shift
{- 1}}} -}

{- Event handling {{{1 -}
myEventHook :: Event -> X All
myEventHook = F.fullscreenEventHook <+> hintsEventHook <+> docksEventHook <+> fadeWindowsEventHook
{- 1}}} -}

{- Status bars and logging {{{1 -}
myLogHook :: X ()
myLogHook = fadeWindowsLogHook myFadeHook
  where myFadeHook = composeAll [
                        opaque
                        , className =? "Gvim"     --> transparency 0.15
                        , className =? "Emacs"    --> transparency 0.15
                        -- , isUnfocused             --> transparency 0.50
                     ]
{- 1}}} -}

{- xmobar {{{1 -}
myBar :: String
myBar = "xmobar"
myPP :: PP
-- hide "Hinted ", length "Hinted " == 7
myPP = xmobarPP {
          ppCurrent   = xmobarColor "#429942" "" . wrap "[" "]"
          , ppLayout  = drop 7
       }
-- toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig {XMonad.modMask = myModMask} = (myModMask, xK_b)
{- 1}}} -}

{- Startup hook {{{1 -}
myStartupHook :: X ()
myStartupHook = setWMName "LG3D"
{- 1}}} -}

{- main {{{1 -}
main :: IO ()
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

defaults = ewmh defaultConfig {
                         -- simple stuff
                         terminal             = myTerminal
                         , focusFollowsMouse  = myFocusFollowsMouse
                         , clickJustFocuses   = myClickJustFocuses
                         , borderWidth        = myBorderWidth
                         , modMask            = myModMask
                         , workspaces         = myWorkspaces
                         , normalBorderColor  = myNormalBorderColor
                         , focusedBorderColor = myFocuseBorderColor

                         -- key bindings
                         , keys               = myKeys
                         , mouseBindings      = myMouseBindings

                         -- hooks, layouts
                         , layoutHook         = myLayoutHook
                         , manageHook         = myManageHook
                         , handleEventHook    = myEventHook
                         , logHook            = myLogHook
                         , startupHook        = myStartupHook
                         }


           `additionalKeys`
           [
              ((myModMask, xK_f), sendMessage $ Toggle FULL)
              , ((myModMask .|. controlMask,  xK_l), sendMessage $ Toggle FULL)

              , ((myModMask, xK_o), runOrRaise "firefox" (className =? "Firefox"))
              , ((myModMask .|. shiftMask, xK_o), runOrRaise "thunderbird" (className =? "Thunderbird"))

              , ((myModMask, xK_a), runOrRaise "dolphin" (className =? "Dolphin"))
              , ((myModMask .|. shiftMask, xK_a), runOrRaise "emacs" (className =? "Emacs"))

              , ((myModMask, xK_e), spawn "gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N")
              -- system gvim
              , ((myModMask .|. shiftMask, xK_e), spawn "/usr/bin/gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N")

              -- Magnifier
              , ((myModMask .|. controlMask , xK_semicolon), sendMessage Mag.MagnifyMore)
              , ((myModMask .|. controlMask , xK_colon), sendMessage Mag.MagnifyLess)
              , ((myModMask .|. controlMask , xK_z ), sendMessage Mag.Toggle )
           ]

{- 1}}} -}

