require 'gtk3'
require_relative 'read_uid'

class GUI

    def scan

	    Thread.new do #comença l'escanejat en thread
		    puts "Waiting for a card scan..."
		    uid = Rfid.new.read_uid
		    puts "Card scanned!"
		    GLib::Idle.add do #GLib::Idle.add permet actualitzar la GUI de manera segura
			    @label.set_markup("<span font='20'>UID: #{uid} </span>")
			    @label.override_background_color(:normal, Gdk::RGBA.new(1, 0, 0, 1))
			    @scanning = false 
			    false #atura GLib::Idle.add
		    end
	    end

    end
    
    def finestra

        Gtk.init
	
	    window = Gtk::Window.new("PUZZLE 2")
        window.set_border_width(10)
        window.set_default_size(500, 150)  
     
        vbox = Gtk::Box.new(:vertical, 0)
     
        @label = Gtk::Label.new
        @label.set_markup("<span font='20'>Please, login with your university card</span>")
        @label.override_background_color(:normal, Gdk::RGBA.new(0, 0, 1, 1))
        @label.override_color(:normal, Gdk::RGBA.new(1, 1, 1, 1))
        @label.set_size_request(500, 100)
     
        button = Gtk::Button.new(label: "Clear")
     
        vbox.pack_start(@label, expand: true, fill: true, padding: 0)
        vbox.pack_start(button, expand: true, fill: true, padding: 10)
     
        scan #primera execució de scan
	    @scanning = true 
        
	    button.signal_connect("clicked") do #torna a l'estat inicial: demanar login i escanejar
		    if !@scanning #evita que s'executi un nou thread quan l'usuari pressiona el botó clear mentre s'escaneja		
			    @label.set_markup("<span font='20'>Please, login with your university card</span>")
			    @label.override_background_color(:normal, Gdk::RGBA.new(0, 0, 1, 1))
			    @scanning = true		
			    scan	 
		    end
	    end
	
	    window.add(vbox)
	    window.show_all
	    window.signal_connect("destroy") { Gtk.main_quit }

	    Gtk.main

    end
     
end

if __FILE__ == $0

    GUI.new.finestra
   
end