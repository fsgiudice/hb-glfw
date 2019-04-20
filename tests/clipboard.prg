/*
The example was taken from the original file
https://github.com/glfw/glfw/blob/master/tests/clipboard.c
It is a copyrighted work provided under license.
Modified by Rafał Jopek
*/

#include "hbglfw.ch"

#if defined(__PLATFORM__DARWIN)
#define MODIFIER GLFW_MOD_SUPER
#else
#define MODIFIER GLFW_MOD_CONTROL
#endif

PROCEDURE Main( argc )

   LOCAL window

   IF argc != NIL
      usage()
      RETURN
   ENDIF

   glfwSetErrorCallback( @error_callback() )

   IF !glfwInit()
      OutStd( e"\nFailed to initialize GLFW" )
      RETURN
   ENDIF

   window := glfwCreateWindow( 200, 200, "Clipboard Test", NIL, NIL )

   IF window == NIL
      glfwTerminate()
      OutStd( e"\nFailed to open GLFW window" )
      RETURN
   ENDIF

   glfwMakeContextCurrent( window )
   gladLoadGL_glfwGetProcAddress()
   glfwSwapInterval( 1 )

   glfwSetKeyCallback( window, @key_callback() )

   glClearColor( 0.5, 0.5, 0.5, 0 )

   DO WHILE !glfwWindowShouldClose( window )
      glClear( GL_COLOR_BUFFER_BIT )

      glfwSwapBuffers( window )
      glfwWaitEvents()

   ENDDO

   glfwTerminate()

   OutStd( e"\nFinishing... ;)" )

   RETURN

STATIC PROCEDURE usage()

   OutStd( e"\nUsage: clipboard [-h]" )

   RETURN

STATIC PROCEDURE error_callback( nError, cDescription )

   HB_SYMBOL_UNUSED( nError )
   OutStd( e"\nError: ", cDescription )

   RETURN

STATIC PROCEDURE key_callback( window, key, scancode, action, mods )

   LOCAL string

   IF action != GLFW_PRESS
      RETURN
   ENDIF

   SWITCH KEY
   CASE GLFW_KEY_ESCAPE
      OutStd( e"\nESCAPE" )
      glfwSetWindowShouldClose( window, GLFW_TRUE )
      EXIT
   CASE GLFW_KEY_V
      IF mods == MODIFIER
         string := glfwGetClipboardString( NIL )
         IF string != NIL
           OutStd( e"\nClipboard contains ", string )
         ELSE
            OutStd( e"\nClipboard does not contain a string" )
         ENDIF
         EXIT
      ENDIF
   CASE GLFW_KEY_C
      IF mods == MODIFIER
         string := "Hello GLFW world!"
         glfwSetClipboardString( NIL, string )
         OutStd( e"\nSetting clipboard to ", string )
         EXIT
      ENDIF
   OTHERWISE
      OutStd( key, scancode, action, mods )
   ENDSWITCH

   RETURN
