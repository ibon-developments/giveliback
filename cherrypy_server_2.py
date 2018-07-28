import cherrypy
from flask_server_2 import app


class webDApp(object):
  @cherrypy.expose
  def index(self):
    return app

cherrypy.tree.graft(app.wsgi_app,'/')


if __name__ == '__main__':
  cherrypy.config.update({'server.socket_port':8889})
  cherrypy.engine.start()
