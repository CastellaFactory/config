----------------------------------------------------------------------
-- XMonad config
----------------------------------------------------------------------

-- import System.IO
-- import XMonad.Layout
-- import XMonad.Util.Run
import Control.Arrow (first)
import Control.Monad (liftM2)
import Data.Char (isSpace)
import Data.List (isInfixOf)
import Data.Monoid (All, Endo)
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmhDesktopsLogHook)
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isDialog, doCenterFloat)
import XMonad.Hooks.SetWMName
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

-- mySetting
myTerminal          :: String
myTerminal          = "urxvt"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myClickJustFocuses  :: Bool
myClickJustFocuses  = False
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
                font      = "xft:Meslo LGM:size=12:bold:antialial=true"
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

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

  [
    -- ターミナル起動(Win+Shift+RET)
    ((modm .|. shiftMask, xK_Return  ), spawn $ XMonad.terminal conf)

    -- shellprompt起動(Win+p)
    , ((modm,               xK_p     ), shellPrompt myXPConfig)

    -- gmrun起動(Win+Shift+p)
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- dmenu起動(Win+Ctrl+p)
    , ((modm .|. controlMask, xK_p   ), spawn "dmenu_run -fn 'CodeM-11:bold'")

    -- フォーカスしているウィンドウを閉じる(Win+Shift+c)
    , ((modm .|. shiftMask, xK_c     ), kill)

    -- レイアウト切り替える(Win+Space)
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  レイアウトをリセット(Win+Shift+Space)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- ウィンドウをリフレッシュ(Win+n)
    , ((modm,               xK_n     ), refresh)

    -- 次のウィンドウにフォーカスを移す(Win+Tab)
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- 次のウィンドウにフォーカスを移す(Win+j)
    , ((modm,               xK_j     ), windows W.focusDown)

    -- 前のウィンドウにフォーカスを移す(Win+k)
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- マスターウィンドウにフォーカスを移す(Win+m)
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- マスターウィンドウとフォーカスウィンドウを入れ替える(Win+RET)
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window(Win+Shift+j)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window(Win+Shift+k)
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- マスターエリアを縮める(Win+h)
    , ((modm,               xK_h     ), sendMessage Shrink)

    --マスターエリアを広げる(Win+l)
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling(Win+t)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area(Win+,)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area(Win+.)
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- XMonadを終了(Win+Shift+q)
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- XMonadを再起動(Win+q)
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
-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--
  [
    ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]


------------------------------------------------------------------------
------------------------------------------------------------------------
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


------------------------------------------------------------------------
-- Layouts:
-- フルスクリーンにするにはWin+F(see additionalkeys)

myLayout = layoutHints
           $ avoidStruts
           $ smartBorders $ Mag.magnifiercz 1.2
           $ mkToggle (NOBORDERS ?? FULL ?? EOT)
           $ Tall 1 (3/100) (1/2) ||| Mirror (Tall 1 (3/100) (1/2))


------------------------------------------------------------------------
-- Window rules:
-- ウィンドウ作成時のデフォルトワークスペース，フローティングの設定
myManageHook :: Query (Endo WindowSet)
myManageHook = manageDocks <+> F.fullscreenManageHook
               <+> composeAll [
               className =? "MPlayer"                               --> doFloat
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
               , isDialog                                             --> doCenterFloat
               ]
  where viewShift = doF . liftM2 (.) W.view W.shift


----------------------------------------------------------------------
-- Event handling
myEventHook :: Event -> X All
myEventHook = F.fullscreenEventHook <+> hintsEventHook <+> docksEventHook <+> fadeWindowsEventHook


------------------------------------------------------------------------
-- Status bars and logging
myLogHook :: X ()
myLogHook  = ewmhDesktopsLogHook <+> fadeWindowsLogHook myFadeHook
  where myFadeHook = composeAll [
                        opaque
                        , isFloating              --> opaque
                        , className =? "URxvt"    --> opaque
                        , className =? "Gvim"     --> transparency 0.20
                        , isUnfocused             --> transparency 0.50
                     ]


------------------------------------------------------------------------
-- Startup hook
myStartupHook :: X ()
myStartupHook = setWMName "LG3D"


------------------------------------------------------------------------
-- xmobar
myBar :: String
myBar = "xmobar"
myPP :: PP
-- Hintedは非表示にする length "Hinted " == 7
myPP = xmobarPP {
          ppCurrent   = xmobarColor "#429942" "" . wrap "[" "]"
          , ppLayout  = drop 7
       }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------
main :: IO ()
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

defaults = defaultConfig {
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
                         , layoutHook         = myLayout
                         , manageHook         = myManageHook
                         , handleEventHook    = myEventHook
                         , logHook            = myLogHook
                         , startupHook        = myStartupHook
                         }


           `additionalKeys`
           [
              ((myModMask, xK_f), sendMessage $ Toggle FULL)
              , ((myModMask .|. controlMask,  xK_l), sendMessage $ Toggle FULL)

              -- アプリケーションを起動
              , ((myModMask, xK_o), runOrRaise "firefox" (className =? "Firefox"))
              , ((myModMask .|. shiftMask, xK_o), runOrRaise "thunderbird" (className =? "Thunderbird"))

              , ((myModMask, xK_a), runOrRaise "dolphin" (className =? "Dolphin"))
              , ((myModMask .|. shiftMask, xK_a), runOrRaise "emacs" (className =? "Emacs"))

              , ((myModMask, xK_e), spawn "gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N")
              , ((myModMask .|. shiftMask, xK_e), spawn "gvim -u ~/.vim/vimrc_practice -U ~/.vim/gvimrc -N")

              -- Magnifier
              , ((myModMask .|. controlMask , xK_semicolon), sendMessage Mag.MagnifyMore)
              , ((myModMask .|. controlMask , xK_colon), sendMessage Mag.MagnifyLess)
              , ((myModMask .|. controlMask , xK_z ), sendMessage Mag.Toggle )
           ]
