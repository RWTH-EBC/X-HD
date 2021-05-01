import json

einzelperson = {"t_crit_DIN": 1,  # in h
                "Q_crit_DIN": 0.945,  # in kWh
                "t_crit_VDI": 1,  # in hz
                "Q_crit_VDI": 0.945,  # in kWh
                "Q_loss_crit": 0,  # in kwh/h
                "daily_vol": 36,  # in liter
                "daily_Q": 2.1}  # in kWh

familie_duschen = {"t_crit_DIN": 1,  # in h
                   "Q_crit_DIN": 2.24,  # in kWh
                   "t_crit_VDI": 1,  # in h
                   "Q_crit_VDI": 2.24,  # in kWh
                   "Q_loss_crit": 0,  # in kwh/h
                   "daily_vol": 100.2,  # in liter
                   "daily_Q": 5.845}  # in kWh

familie_duschen_baden = {"t_crit_DIN": 1,  # in h
                         "Q_crit_DIN": 4.445,  # in kWh
                         "t_crit_VDI": 1,  # in h
                         "Q_crit_VDI": 4.445,  # in kWh
                         "Q_loss_crit": 0,  # in kwh/h
                         "daily_vol": 199.8,  # in liter
                         "daily_Q": 11.655}  # in kWh

data = {'profil': 'einzelperson',
        'einzelperson': einzelperson,
        'familie_duschen': familie_duschen,
        'familie_duschen_baden': familie_duschen_baden,
        'T_kW': 10,  # in°C
        'T_TWW_set': 50,  # in°C
        'T_biv': -2,  # in°C
        'f_HW': 1,
        'f_TWW': 1,
        'c_w': 0.001163,  # in kWh/(lK)
        'v_Sp_WW_min': 12,  # in l
        'v_Sp_WW_max': 35,  # in l
        'v_Sp_WW': 23.5,  # in l
        'bivalent': True,
        'Gebaeudeart': "single_family_house",
        'Baujahr': 1980,
        'Nutzflaeche': 222,
        'Deckenhoehe': 2,
        'Geschosszahl': 3,
        'luefter': False,
        'Modernisiert': "tabula_standard",
        'bundesland': 'Baden Württemberg',
        'kreis': 'Alb_Donau_Land',
        # Daten VDI
        'f_TWE': 1.15,
        'n_E': 1,
        'T_zirkRL': 55,  # in°C
        'Q_zirk': 0,  # in kWh
        't_SD': 4,  # in h
        'T_HG': 12,  # in°C
        'T_NA': -12,  # in°C
        'Q_sonst': 0,  # in kWh
        'Q_ind': 0,  # individuell angegebene Heizlast in kW
        # daten Teaser
        'T_heiz': -12,
        'wetterdaten': 'TRY2015_511981064800_Jahr_City_Moenchengladbach.mos',
        'residential': True,
        # individuelles Design
        'ind_dict': {'V_Sp_TWW': 0, 'V_Sp_WW': 0, 'Q_WP_AP': 0, 'Q_HS_AP': 0}
        }

with open('config_default.json', 'w') as configfile:
    json.dump(data, configfile)
