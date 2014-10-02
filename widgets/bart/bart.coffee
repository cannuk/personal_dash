class Dashing.Bart extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @stationElem = $(@node).find('.station')
    @estimatesElem = $(@node).find('.estimates')
    @wrapElem = $(@node).find('.wrap')
    @nextDestination()
    @startCarousel() if @destinations.length > 0

  onData: (data) ->
    @currentIndex = 0 unless @currentIndex
    @updateDestination()

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "10"
    console.log interval
    setInterval(@nextDestination, parseInt( interval ) * 1000)

  updateDestination: =>
    @destinations = @get("destinations")



  formatEstimate: (est) =>
    "<div class='estimate'><div class='time'>#{est.minutes.toString().lpad("&nbsp;", 2)} min</div><div class='cars'>#{est.train_length.toString().lpad("&nbsp;", 2)} cars</div></div>"



  nextDestination: =>
    if @destinations? and @destinations.length > 0
#      @wrapElem.fadeOut =>
        @currentIndex = if (@currentIndex + 1)  >=  @destinations.length then 0 else (@currentIndex + 1)
        curr_dest = @destinations[@currentIndex]
        curr_dest.formatted_estimates = ""
        curr_dest.formatted_estimates += @formatEstimate estimate for estimate in curr_dest.estimates
        @set 'curr_dest', curr_dest
#        @wrapElem.fadeIn()

#stding padding function
if (typeof String::lpad != 'function')
  String::lpad = (padString, length) ->
    str = this
    while str.length < length
      str = padString + str
    return str