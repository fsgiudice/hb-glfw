
#include "hbglfw.ch"

PROCEDURE Main()

   LOCAL ratio
   LOCAL width, height
   LOCAL window

   glfwSetErrorCallback( @error_callback() )

   IF !glfwInit()
      OutStd( e"\nFailed to initialize GLFW" )
      RETURN
   ENDIF

   window := glfwCreateWindow( 640, 480, "Simple example", NIL, NIL )

   IF window == NIL
      glfwTerminate()
      OutStd( e"\nFailed to open GLFW window" )
      RETURN
   ENDIF

   glfwMakeContextCurrent( window )
   gladLoadGL_glfwGetProcAddress()
   glfwSetKeyCallback( window, @key_callback() )

   DO WHILE ! glfwWindowShouldClose( window )

      glfwGetFramebufferSize( window, @width, @height )
      ratio := width / height
      OutStd( width )

      glViewport( 0, 0, width, height )
      glClear( GL_COLOR_BUFFER_BIT )
      glMatrixMode( GL_PROJECTION )
      glLoadIdentity()
      glOrtho( -ratio, ratio, -1, 1, 1, -1 )
      glMatrixMode( GL_MODELVIEW )
      glLoadIdentity()
      glRotatef( glfwGetTime() * 50, 0, 0, 1 )
      glBegin( GL_TRIANGLES )
      glColor3f( 1, 0, 0 )
      glVertex3f( -0.6, -0.4, 0 )
      glColor3f( 0, 1, 0 )
      glVertex3f( 0.6, -0.4, 0 )
      glColor3f( 0, 0, 1 )
      glVertex3f( 0, 0.6, 0 )
      glEnd()
      glfwSwapBuffers( window )
      glfwPollEvents()

   ENDDO

   glfwDestroyWindow( window )

   glfwTerminate()

   OutStd( e"\nFinishing... ;)" )

   RETURN

STATIC PROCEDURE error_callback( nError, cDescription )

   HB_SYMBOL_UNUSED( nError )
   OutStd( e"\nError: ", cDescription )

   RETURN

STATIC PROCEDURE key_callback( window, key, scancode, action, mods )

   HB_SYMBOL_UNUSED( scancode )
   HB_SYMBOL_UNUSED( mods )

   IF key == GLFW_KEY_ESCAPE .AND. action == GLFW_PRESS
      glfwSetWindowShouldClose( window, GL_TRUE )
   ENDIF

   RETURN
