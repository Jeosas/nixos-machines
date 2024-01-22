{ config, pkgs, ... }:

{
  xdg.configFile."regolith2/Xresources".text = ''
    ! Look
    gnome.terminal.font: ${config.theme.fonts.mono} 11
    gtk.document_font_name:	Sans 11
    gtk.font_name: ${config.theme.fonts.sans} 11	
    gtk.monospace_font_name: ${config.theme.fonts.mono} 11	
    i3-wm.bar.font:	${config.theme.fonts.sans} 11
    i3-wm.floatingwindow.border.size:	2
    i3-wm.window.border.size:	2
    !i3-wm.workspace.01.name:	1:<span> </span><span foreground="#5E81AC">一</span><span> </span>
    !i3-wm.workspace.02.name:	2:<span> </span><span foreground="#88C0D0">二</span><span> </span>
    !i3-wm.workspace.03.name:	3:<span> </span><span foreground="#A3BE8C">三</span><span> </span>
    !i3-wm.workspace.04.name:	4:<span> </span><span foreground="#EBCB8B">四</span><span> </span>
    !i3-wm.workspace.05.name:	5:<span> </span><span foreground="#D08770">五</span><span> </span>
    !i3-wm.workspace.06.name:	6:<span> </span><span foreground="#BF616A">六</span><span> </span>
    !i3-wm.workspace.07.name:	7:<span> </span><span foreground="#5E81AC">七</span><span> </span>
    !i3-wm.workspace.08.name:	8:<span> </span><span foreground="#B48EAD">八</span><span> </span>
    !i3-wm.workspace.09.name:	9:<span> </span><span foreground="#7B8394">九</span><span> </span>
    !i3-wm.workspace.10.name:	10:<span> </span><span foreground="#5E81AC">十</span><span> </span>
    i3xrocks.label.cpu:	󰡵
    i3xrocks.value.font: ${config.theme.fonts.sans} 11
    regolith.look.path:	/usr/share/regolith-look/nord
    !regolith.lockscreen.wallpaper.file:	/usr/share/regolith-look/nord/nord-dark.png
    !regolith.lockscreen.wallpaper.options:	zoom
    !regolith.wallpaper.file:	/usr/share/regolith-look/nord/nord-regolith2-noText-GMFranceschini.svg
    !regolith.wallpaper.options:	zoom

    ! Programs

    ! Shortcuts
    i3-wm.binding.launcher.app: d
    i3-wm.binding.split_h: s
    i3-wm.binding.exit_app: Shift+a
    i3-wm.binding.kill_app: a
    i3-wm.binding.shutdown: Shift+q
    i3-wm.binding.lock: Shift+d
    i3-wm.binding.display: p
  '';

  xdg.configFile."regolith2/i3/config.d/90_autotiling".text = ''
    exec --no-startup-id ${pkgs.autotiling}/bin/autotiling &
    exec --no-startup-id syndaemon -R -d -i 0.2
  '';
}
