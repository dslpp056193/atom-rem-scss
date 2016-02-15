PxToRem = require '../lib/atom-rem-scss'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomRemScss", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    activationPromise = atom.packages.activatePackage('atom-rem-scss')
    waitsForPromise ->
        atom.workspace.open 'c.coffee'

  it "converts", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText("25.5px;")
    editor.selectAll()
    changeHandler = jasmine.createSpy('changeHandler')
    editor.onDidChange(changeHandler)

    atom.commands.dispatch workspaceElement, 'atom-rem-scss:convert'

    waitsForPromise ->
      activationPromise

    waitsFor "change event", ->
      changeHandler.callCount > 0

    runs ->
      expect(editor.getText()).toEqual("1.59375rem;")
