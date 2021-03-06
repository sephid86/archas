def Settings( **kwargs ):
    return {
            'flags': [
                '-x',
                'c',
                '-std=c11',
                '-I./src',
                '-I./data',
                '-I./data/model',
                '-I/usr/include',
                '-I/usr/include/cairo',
                '-I/usr/include/glib-2.0',
                '-I/usr/include/pixman-1',
                '-I/usr/include/freetype2',
                '-I/usr/include/libpng12',
                '-I/usr/include/gstreamer-1.0',
                '-I/usr/include/alsa',
                '-I/usr/include/libdrm',
                '-I/usr/include/GL',
                '-I/usr/include/gtk-3.0',
                '-I/usr/include/atk-1.0',
                '-I/usr/include/at-spi2-atk/2.0',
                '-I/usr/include/pango-1.0',
                '-I/usr/include/gio-unix-2.0/',
                '-I/usr/include/gdk-pixbuf-2.0',
                '-I/usr/include/openssl',
                '-I/usr/include/harfbuzz',
                '-I.'
                ],
            }
