/**
 * GaiaEHR (Electronic Health Records)
 * Copyright (C) 2013 Certun, LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

Ext.define('App.view.patient.windows.Medical', {
	extend: 'App.ux.window.Window',
	title: _('medical_window'),
	itemId: 'MedicalWindow',
	closeAction: 'hide',
	//bodyStyle: 'background-color:#fff',
	modal: true,
	requires: [
		'App.view.patient.Results',
		'App.view.patient.Referrals',
		'App.view.patient.Immunizations',
		'App.view.patient.Medications',
		'App.view.patient.ActiveProblems',
		'App.view.patient.SocialPanel',
		'App.view.patient.Allergies',
		'App.view.patient.AdvanceDirectives',
		'App.view.patient.CognitiveAndFunctionalStatus',
		'App.view.patient.LabOrders',
		'App.view.patient.RadOrders',
		'App.view.patient.RxOrders',
		'App.view.patient.DoctorsNotes',
		'App.view.patient.FamilyHistory',
		'App.view.patient.ImplantableDevice',
		'App.view.patient.SocialPsychologicalBehavioral'
	],

	initComponent: function(){
		var me = this,
			tapPanelItems = [];


		if(a('access_patient_immunizations')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'patientimmunizationspanel',
				itemId: 'immunization',
				tabConfig: {
					tooltip: _('vaccines_immunizations')
				}
			});
		}

		if(a('access_patient_allergies')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientallergiespanel',
				itemId: 'allergies',
				tabConfig: {
					tooltip: _('allergies')
				}
			});
		}

		if(a('access_active_problems')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientactiveproblemspanel',
				itemId: 'activeproblems',
				tabConfig: {
					tooltip: _('active_problems')
				}
			});
		}

		if(a('access_family_history')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientfamilyhistorypanel',
				itemId: 'familyhistory',
				tabConfig: {
					tooltip: _('family_history')
				}
			});
		}

		if(a('access_patient_advance_directive')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientadvancedirectivepanel',
				itemId: 'advancedirectives',
				tabConfig: {
					tooltip: _('advance_directives')
				}
			});
		}

		if(a('access_patient_medications')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'patientmedicationspanel',
				itemId: 'medications',
				tabConfig: {
					tooltip: _('medications')
				}
			});
		}

		if(a('access_patient_results')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'patientresultspanel',
				itemId: 'laboratories',
				tabConfig: {
					tooltip: _('results')
				}
			});
		}

		if(a('access_patient_social_history')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientsocialpanel',
				itemId: 'social',
				tabConfig: {
					tooltip: _('social_history')
				}
			});
		}

		if(a('access_patient_functional_status')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientcognitiveandfunctionalstatuspanel',
				itemId: 'functionalstatus',
				tabConfig: {
					tooltip: _('functional_status')
				}
			});
		}

		if(a('access_patient_referrals')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientreferralspanel',
				itemId: 'referrals',
				tabConfig: {
					tooltip: _('referrals')
				}
			});
		}

		if(a('access_patient_implantable_devices')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'implantabledevicepanel',
				tabConfig: {
					tooltip: _('implantable_devices')
				}
			});
		}

		if(a('access_patient_psy_behavioral')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'socialpsychologicalbehavioralpanel',
				tabConfig: {
					tooltip: _('social_psychological_behavioral')
				}
			});
		}

		if(a('access_patient_doctors_notes')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientdoctorsnotepanel',
				tabConfig: {
					tooltip: _('doctors_notes')
				}
			});
		}

		if(a('access_patient_lab_orders')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientlaborderspanel'
			});
		}

		if(a('access_patient_rad_orders')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype: 'patientradorderspanel'
			});
		}

		if(a('access_patient_rx_orders')){
			tapPanelItems = Ext.Array.push(tapPanelItems, {
				xtype:'patientrxorderspanel'
			});
		}


		me.items = [
			{
				xtype:'tabpanel',
				border:false,
				bodyBorder:false,
				plain: true,
				margin: 5,
				height: Ext.getBody().getHeight() < 700 ? (Ext.getBody().getHeight() - 100) : 600,
				width: Ext.getBody().getWidth() < 1550 ? (Ext.getBody().getWidth() - 50) : 1500,
				items: tapPanelItems
			}
		];

		me.buttons = [
			{
				text: _('close'),
				scope: me,
				handler: function(){
					me.close();
				}
			}
		];

		me.listeners = {
			scope: me,
			close: me.onMedicalWinClose,
			show: me.onMedicalWinShow
		};

		me.callParent(arguments);
	},

	cardSwitch:function(action){
		var me = this,
			tabPanel = me.down('tabpanel'),
			activePanel = tabPanel.getActiveTab(),
			toPanel = tabPanel.query('#' + action)[0];

		if(activePanel == toPanel){
			activePanel.fireEvent('activate', activePanel);
		}else{
			tabPanel.setActiveTab(toPanel);
			me.setWindowTitle(toPanel.title);
		}
	},

	setWindowTitle:function(title){
		this.setTitle(app.patient.name + ' (' + title + ') ' + (app.patient.readOnly ? '-  <span style="color:red">[Read Mode]</span>' :''));
	},

	onMedicalWinShow: function(){
		var p = this.down('tabpanel'),
			w = Ext.getBody().getWidth() < 1550 ? (Ext.getBody().getWidth() - 50) : 1500,
			h = Ext.getBody().getHeight() < 700 ? (Ext.getBody().getHeight() - 100) : 600;
		p.setSize(w, h);
		this.alignTo(Ext.getBody(), 'c-c');
	},

	onMedicalWinClose: function(){
		if(app.getActivePanel().$className == 'App.view.patient.Summary'){
			app.getActivePanel().loadStores();
		}
	}
});
