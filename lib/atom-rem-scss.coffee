pxPattern = /// ^ # begin of line
    (\s*)         # zero or more spaces
    (\d+(.\d+)?)  # one or more numbers
    (\s*)         # zero or more spaces
    (px)          # followed by px letters
    (\s*)         # zero or more spaces
    (;*)          # for cases that the user select within
    $ ///i        # end of line and ignore cases

ColorConverterView = require './atom-rem-scss-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomRemScss =
    subscriptions: null

    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add 'atom-workspace',
            'atom-rem-scss:toggle': => @convert()

    deactivate: ->
        @subscriptions.dispose()

    convert: ->
        editor = atom.workspace.getActiveTextEditor()
        selections = editor.getSelections()
        buffer = editor.getBuffer()

        # Group these actions so they can be undone together
        buffer.transact ->
          for selection in selections

            original = text = selection.getText()
            if text.match pxPattern
                num = parseFloat(text)
                semicolon = text.slice(-1)
                if semicolon.match ";"
                    selection.insertText('rem(' + num + ");")
                else
                    selection.insertText('rem(' + num + ")")
            else
                selection.insertText(original)
