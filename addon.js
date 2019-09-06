"use strict"

const path = require("path")
const UIPage  = require(path.dirname(module.parent.filename) + '/../mod/uipage')
const fs = require('fs')

class Analytics extends UIPage {

	constructor(tool, i18n) {
		super('Analytics')

		const self = this
		this._tool = tool
		this._i18n = i18n
		this._view = document.createElement('anaframe')
		this._contentElement = document.createElement('div')
		this._contentElement.appendChild(this._view)

		let anaframeTag = fs.readFileSync(__dirname.replace(/\\/g, '/') + '/res/anaframe.tag', { encoding: 'utf8' })
		let {code} = riot.compileFromString(anaframeTag)
		riot.inject(code, 'anaframe', __dirname.replace(/\\/g, '/') + '/res/anaframe.tag')

		document.querySelector('#contents').appendChild(this._contentElement)
		riot.mount(this._view, { addon: this })
	}

	open() {
		this._contentElement.style.display = 'block'
		this._view._tag.openStats(this._tool.auth.username)
	}

	close() {
		this._contentElement.style.display = 'none'
		this._view._tag.clearStats()
	}

	get icon() {
		return 'BIDashboard'
	}
}
module.exports = Analytics