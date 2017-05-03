----------------------------------------------------------------------
-- XMonad config
----------------------------------------------------------------------

{- Import {{{1 -}
import           Codec.Binary.UTF8.String            (decodeString)
import           Control.Monad                       (forM, forM_, liftM2,
                                                      replicateM)
import qualified Data.Map                            as M (Map, fromList, union)
import           Graphics.X11.ExtraTypes.XF86        (xF86XK_AudioLowerVolume,
                                                      xF86XK_AudioMute,
                                                      xF86XK_AudioRaiseVolume)
import           System.Directory                    (getTemporaryDirectory,
                                                      removeFile)
import           System.Exit                         (exitSuccess)
import           System.IO                           (FilePath, hClose,
                                                      openTempFile)
import           System.Posix.Env                    as Env (putEnv)
import           System.Posix.Files                  (createNamedPipe,
                                                      ownerReadMode,
                                                      ownerWriteMode,
                                                      unionFileModes)
import           XMonad
import           XMonad.Actions.Submap               (submap)
import           XMonad.Actions.UpdatePointer        (updatePointer)
import           XMonad.Actions.WindowGo             (runOrRaise)
import           XMonad.Hooks.DynamicLog             (PP, dynamicLogWithPP,
                                                      ppCurrent, ppHidden,
                                                      ppHiddenNoWindows,
                                                      ppLayout, ppOrder,
                                                      ppOutput, ppTitle,
                                                      ppVisible, shorten,
                                                      xmobarColor)
import           XMonad.Hooks.EwmhDesktops           (ewmh, fullscreenEventHook)
import           XMonad.Hooks.FadeWindows            (fadeWindowsEventHook,
                                                      fadeWindowsLogHook,
                                                      opaque, transparency)
import           XMonad.Hooks.ManageDocks            (ToggleStruts (ToggleStruts),
                                                      avoidStruts, docks)
import           XMonad.Hooks.ManageHelpers          (doCenterFloat, isDialog)
import           XMonad.Hooks.SetWMName              (setWMName)
import           XMonad.Layout.Grid                  (Grid (Grid))
import           XMonad.Layout.IndependentScreens    (countScreens, marshallPP,
                                                      onCurrentScreen,
                                                      whenCurrentOn,
                                                      withScreens, workspaces')
import           XMonad.Layout.LayoutHints           (hintsEventHook,
                                                      layoutHints)
import qualified XMonad.Layout.Magnifier             as Mag (MagnifyMsg (MagnifyLess),
                                                             MagnifyMsg (MagnifyMore),
                                                             MagnifyMsg (Toggle),
                                                             magnifiercz)
import           XMonad.Layout.MultiToggle           (EOT (EOT),
                                                      Toggle (Toggle), mkToggle,
                                                      (??))
import           XMonad.Layout.MultiToggle.Instances (StdTransformers (FULL))
import           XMonad.Layout.NoBorders             (smartBorders)
import qualified XMonad.StackSet                     as W
import           XMonad.Util.Run                     (spawnPipe, unsafeSpawn)
import           XMonad.Util.SpawnOnce               (spawnOnce)
{- 1}}} -}

{- main {{{1 -}
main :: IO ()
main = do
  numScreens <- countScreens
  xmobarOpts <- forM [0 .. numScreens - 1]
                  $ \n -> do
                    [focusPipe, workspacesPipe] <- replicateM 2 (getNamedPipe "xmobar-")
                    return $ XMobarOpts n focusPipe workspacesPipe
  mapM_ (spawnPipe . xmobarCommand) xmobarOpts

  xmonad $ ewmh $ docks $ def {
                         terminal             = "urxvt"
                         , focusFollowsMouse  = False
                         , clickJustFocuses   = False
                         , borderWidth        = 3
                         , modMask            = mod4Mask
                         , normalBorderColor  = "blue"
                         , focusedBorderColor = "orange"
                         , workspaces         = withScreens numScreens $ map show [1 .. 9]

                         -- key bindings
                         , keys               = myKeys
                         , mouseBindings      = myMouseBindings

                         -- hooks, layouts
                         , layoutHook         = layoutHints
                                                  $ avoidStruts
                                                  $ smartBorders
                                                  $ mkToggle (FULL ?? EOT)
                                                  $ Mag.magnifiercz 1.4
                                                  $ Tall 1 (3/100) (1/2) ||| Grid

                         , manageHook         = composeAll
                                                    [ isDialog                      --> doCenterFloat
                                                    , className =? "MPlayer"        --> doFloat
                                                    , className =? "Smplayer"       --> doFloat
                                                    , className =? "Kmix"           --> doFloat
                                                    , resource  =? "desktop_window" --> doIgnore
                                                    , resource  =? "kdesktop"       --> doIgnore
                                                    ]

                         , handleEventHook    = handleEventHook def
                                                  <+> hintsEventHook
                                                  <+> fadeWindowsEventHook
                                                  <+> fullscreenEventHook

                         , logHook            = do
                                                updatePointer (0.5, 0.5) (1, 1)
                                                forM_ xmobarOpts $ \(XMobarOpts n focusPipe workspacesPipe) -> do
                                                    dynamicLogWithPP $ focusPP focusPipe n
                                                    dynamicLogWithPP $ workspacesPP workspacesPipe n
                                                fadeWindowsLogHook
                                                  $ composeAll
                                                    [ opaque
                                                    , className =? "Gvim"  --> transparency 0.15
                                                    , className =? "Emacs" --> transparency 0.15
                                                    ]

                         , startupHook        = do
                                                  setWMName "LG3D"
                                                  liftIO $ Env.putEnv "_JAVA_AWT_WM_NONREPARENTING=1"
                                                  liftIO $ Env.putEnv "XDG_CURRENT_DESKTOP=KDE"
                                                  -- spawnOnce "compton -b -C -G --config ~/.compton.conf"
                                                  -- spawnOnce "/usr/lib64/libexec/polkit-kde-authentication-agent-1"
                                                  -- spawnOnce "stalonetray"
                                                  -- spawnOnce "nitrogen --restore"
                                                  -- spawnOnce "kmix --keepvisibility"
                                                  -- spawnOnce "fcitx-autostart"
                                                  -- spawnOnce "insync start"
                                                  -- spawnOnce "dropbox"
                                                  -- spawnOnce "xset -b"
                                                  -- spawnOnce "xrdb -merge ~/.Xresources"
                         }
{- 1}}} -}

{- Key bindings {{{1 -}
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig { XMonad.modMask = modMask } = M.fromList $
  [ ((modMask .|. shiftMask, xK_Return), unsafeSpawn $ XMonad.terminal conf)
  , ((modMask,               xK_p     ), unsafeSpawn "rofi\
                                                      \ -combi-modi window,drun,run\
                                                      \ -show combi\
                                                      \ -modi combi\
                                                      \ -color-enabled true\
                                                      \ -color-normal '#273238,#c1c1c1,#273238,#394249,#ffffff'\
                                                      \ -color-active '#273238,#80cbc4,#273238,#394249,#80cbc4'\
                                                      \ -color-urgent '#273238,#ff1844,#273238,#394249,#ff1844'\
                                                      \ -hide-scrollbar\
                                                      \ -font 'Source Han Code JP medium 16'\
                                                      \ -kb-cancel 'Escape,Control+g,Control+c,Control+bracketleft'")
  , ((modMask .|. shiftMask, xK_c     ), kill)
  , ((modMask,               xK_space ), sendMessage NextLayout)
  , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
  , ((modMask,               xK_n     ), refresh)
  , ((modMask,               xK_Tab   ), windows W.focusDown)
  , ((modMask,               xK_j     ), windows W.focusDown)
  , ((modMask,               xK_k     ), windows W.focusUp)
  , ((modMask,               xK_m     ), windows W.focusMaster)
  , ((modMask,               xK_Return), windows W.swapMaster)
  , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown)
  , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp)
  , ((modMask,               xK_h     ), sendMessage Shrink)
  , ((modMask,               xK_l     ), sendMessage Expand)
  , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
  , ((modMask,               xK_comma ), sendMessage (IncMasterN 1))
  , ((modMask,               xK_period), sendMessage (IncMasterN (-1)))
  , ((modMask .|. shiftMask, xK_q     ), io exitSuccess)
  , ((modMask,               xK_q     ), unsafeSpawn "pkill xmobar" >> unsafeSpawn "xmonad --recompile; xmonad --restart")
  , ((0,       xF86XK_AudioLowerVolume), unsafeSpawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ((0,       xF86XK_AudioRaiseVolume), unsafeSpawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ((0,              xF86XK_AudioMute), unsafeSpawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  ]
  ++
  [ ((m .|. modMask, k), windows $ onCurrentScreen f i)
    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]
  ++
  [ ((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_v, xK_z] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  [ ((modMask,                  xK_f), sendMessage $ Toggle FULL)
  , ((modMask .|. controlMask,  xK_l), sendMessage $ Toggle FULL)
  , ((modMask,                  xK_b), sendMessage ToggleStruts)

  , ((modMask,                  xK_o), runOrRaise "google-chrome-stable" (className =? "Google-chrome"))
  , ((modMask .|. shiftMask,    xK_o), runOrRaise "thunderbird-bin" (className =? "Thunderbird"))

  , ((modMask,                  xK_a), runOrRaise "dolphin" (className =? "dolphin"))
  , ((modMask .|. shiftMask,    xK_a), runOrRaise "emacs" (className =? "Emacs"))

  , ((modMask,                  xK_e), unsafeSpawn "gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N")
  , ((modMask .|. shiftMask,    xK_e), unsafeSpawn "/usr/bin/gvim -u ~/.vim/vimrc -U ~/.vim/gvimrc -N")

  -- Magnifier
  , ((modMask .|. controlMask,               xK_semicolon), sendMessage Mag.MagnifyMore)
  , ((modMask .|. controlMask .|. shiftMask, xK_semicolon), sendMessage Mag.MagnifyLess)
  , ((modMask .|. controlMask,                       xK_z), sendMessage Mag.Toggle )
  ]

{- 1}}} -}

{- Mouse bindings {{{1 -}
myMouseBindings :: XConfig t -> M.Map (KeyMask, Button) (Window -> X())
myMouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1), \w -> focus w >> mouseMoveWindow w
                          >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
  , ((modMask, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
  , ((modMask, button3), \w -> focus w >> mouseResizeWindow w
                            >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]
{- 1}}} -}

{- xmobar {{{1 -}
type FocusPipe      = FilePath
type WorkspacesPipe = FilePath
data XMobarOpts     = XMobarOpts ScreenId FocusPipe WorkspacesPipe

xmobarCommand :: XMobarOpts -> String
xmobarCommand (XMobarOpts (S n) focus ws) =
  "xmobar\
   \ -x " ++ show n ++ "\
   \ -C '[Run PipeReader \"" ++ focus ++ "\" \"focus\", \
         \Run PipeReader \"" ++ ws ++ "\" \"workspaces\"]'"

getNamedPipe :: String -> IO FilePath
getNamedPipe prefix = do
  tmpDir <- getTemporaryDirectory
  (tmpFile, h) <- openTempFile tmpDir prefix
  hClose h
  removeFile tmpFile
  createNamedPipe tmpFile $ unionFileModes ownerReadMode ownerWriteMode
  return tmpFile

focusPP :: FocusPipe -> ScreenId -> PP
focusPP pipe (S s) = whenCurrentOn (S s) def {
          ppTitle = xmobarColor "green" "" . shorten 45
          , ppOrder = \(_:_:title:_) -> [title]
          , ppOutput = appendFile pipe . decodeString . (++ "\n")
       }

workspacesPP :: WorkspacesPipe -> ScreenId -> PP
workspacesPP pipe (S s) = marshallPP (S s) def {
          ppCurrent = xmobarColor "green" ""
          , ppVisible = xmobarColor "white" ""
          , ppHiddenNoWindows = xmobarColor "#006666" ""
          , ppOrder = \(ws:_:_:_) -> [ws]
          , ppOutput  = appendFile pipe . (++ "\n")
       }
{- 1}}} -}

