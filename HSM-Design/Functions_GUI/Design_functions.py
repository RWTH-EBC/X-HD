import numpy as np
import os
import DyMat
import plotly.express as px
import pandas as pd


def visualize_res(df_res, y):
    title_dict = {'demand_heat': 'Heat demand',
                  'demand_dhw': 'Domestic hot water demand',
                  'produced_heat': 'Produced heat of HP',
                  'relative_hp': 'Relative power of HP',
                  'electrical_hp': 'Electrical demand of HP',
                  'electrical_hr': 'Electrical demand of HR',
                  'relative_hr': 'Relative power of HR',
                  'cop': 'COP',
                  'amb_temp': 'Ambient temperature',
                  'sto_dhw_top': 'Domestic hot water storage temperature at top',
                  'sto_buf_top': 'Buffer storage temperature at top',
                  'time': 'Time'}

    fig = px.line(df_res, x='time', y=y)

    fig.update_traces(mode='lines+markers')

    fig.update_xaxes(showgrid=True)
    fig.update_xaxes(title='Hours of the year')

    fig.add_annotation(x=0, y=0.85, xanchor='left', yanchor='bottom',
                       xref='paper', yref='paper', showarrow=False, align='left',
                       bgcolor='rgba(255, 255, 255, 0.5)', text=title_dict[y])

    fig.update_layout(height=225, margin={'l': 20, 'b': 30, 'r': 10, 't': 10})

    return fig


def df_creator(df_res_path):
    dmf = DyMat.DyMatFile(df_res_path)
    # nominal powers
    nominal_hp = dmf.data('generationCase.heatPump.Q_flowTableMax')[0] #  Q_flowNom
    nominal_hr = dmf.data('generationCase.heatingRod.P_elNom')[0]
    plot_dict = {'demand_heat': dmf.data('demandCase.buildingDemandCase.building.TimeTable_QDem.y[1]')[240:],
                 'demand_dhw': dmf.data('demandCase.dhwDemandCase.dhw.TimeTable_DHW.y[1]')[240:],
                 'produced_heat': dmf.data('generationCase.heatPump.SwitchHeatFlowCondenser.y')[240:],
                 'relative_hp': dmf.data('generationCase.heatPump.SwitchHeatFlowCondenser.y')[240:] / nominal_hp,
                 'electrical_hp': dmf.data('generationCase.heatPump.P_el')[240:],
                 'electrical_hr': dmf.data('generationCase.heatingRod.P_el')[240:],
                 'relative_hr': dmf.data('generationCase.heatingRod.switch1.y')[240:] / nominal_hr,
                 'cop': dmf.data('generationCase.heatPump.Table_COP.y')[240:],
                 'amb_temp': dmf.data('combiTimeTable_T_amb.y[1]')[240:],
                 'sto_dhw_top': dmf.data('demandCase.T_stoTopDhw')[240:],
                 'sto_buf_top': dmf.data('demandCase.T_stoTopBuf')[240:],
                 'time': np.arange(0, len(dmf.data('demandCase.T_stoTopDhw')[240:]), 1)}
    df_res = pd.DataFrame.from_dict(plot_dict)
    return df_res
