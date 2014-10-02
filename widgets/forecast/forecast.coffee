class Dashing.Forecast extends Dashing.Widget

  # Overrides Dashing.Widget method in dashing.coffee
  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      timestamp = new Date(updatedAt * 1000)
      hours = timestamp.getHours()
      minutes = ("0" + timestamp.getMinutes()).slice(-2)
      "Updated at #{hours}:#{minutes}"

  constructor: ->
    super
    @forecast_icons = new Skycons({"color": "white"})
    @forecast_icons.play()
    @current_id = "current_icon_#{@id}"
    @next_id = "next_icon_#{@id}"
    @later_id = "later_icon_#{@id}"

  ready: ->
    # This is fired when the widget is done being rendered
    @setIcons()

  onData: (data) ->
    # Handle incoming data
    # We want to make sure the first time they're set is after ready()
    # has been called, or the Skycons code will complain.
    if @forecast_icons.list.length
      @setIcons()

  setIcons: ->
    @setIcon("current_icon")
    @setIcon("next_icon")
    @setIcon("later_icon")
    @forecast_icons.play()

  setIcon: (name) ->
    skycon = @toSkycon(name)
    @forecast_icons.set("#{name}_#{@id}", eval(skycon)) if skycon

  toSkycon: (data) ->
    if @get(data)
      'Skycons.' + @get(data).replace(/-/g, "_").toUpperCase()
