import matplotlib.pyplot as plt
import seaborn as sn
from IPython.core.pylabtools import figsize
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine
import os


def create_snowflake_engine():
    """

    :return:
    """
    snowflake_url = URL(account=os.environ.get('SNOWFLAKE_ACCOUNT'),
                        user=os.environ.get('SNOWFLAKE_USER'),
                        password=os.environ.get('SNOWFLAKE_PASSWORD'),
                        warehouse='USER_ADHOC',
                        database='BUSINESS_ANALYTICS',
                        schema='_DS_DEV')
    return create_engine(snowflake_url)


def correlation_result(df, column1, column2):
    """Function takes in a dataframe and provides a correlation coefficient
       for any two columns defined in the function.
       df.columns to see what are the column names

    :param df: Pandas DataFrame
    :type:    dataframe

    :param column1: Column name with the dataframe
    :type:          columns

    :param column2: Column name with the dataframe
    :type:          columns

    Example: correlation_results(df, 'my_first_column', 'my_second_column')
    """

    col1 = df[column1]
    col2 = df[column2]
    corr_result = round(col1.corr(col2), 2)
    print(f"Correlation {column1} and {column2} is {corr_result}")


def plot_correlation(df=None, y_column=None, x_column=None, title=None, x_label=None, figure=None):
    """Takes in dataframe and columns within the dataframe and plots a scatter plot
       including title and x axis labels.
       This plots only one plot at a time cannot pass in multiple columns to do a scatter plot.
       NOTE: y_label is hard coded in this function. Changes can be made in utils.py

   :params df: A Dataframe needs to be passed in
   :type:      Pandas dataframe

   :params y_column: A column name from the dataframe in quotes
   :type:            str
   :Example:         y_column='prcnt_chng_cpmh'

   :params x_column: A column name from the dataframe in quotes
   :type:            str
   :Example:         x_column='prcnt_chng_avg_selector_days'

   :params title:    A string as a title of the plot
   :type:            str
   :Example:         title='Scatter Plot CPMH percent change YoY vs Average Selector day percent change YoY'

   :params x_label:  A string for the x axis
   :type:            str
   :Example:         title='Scatter Plot CPMH percent change YoY vs Average Selector day percent change YoY'

   :params figure:   A string for the x axis
   :type:            str
   :Example:         figure='CPMH_vs_Avg_Selector_Days.png'

   :Example:        Function in use.
                    plot_correlation(df=all_mkts_df,
                                     y_column='prcnt_chng_cpmh',
                                     x_column='prcnt_chng_avg_selector_days',
                                     title='Sactter Plot CPMH percent change YoY vs Average Selector day percent change YoY',
                                     x_label='Average Selector day change YoY',
                                     figure='data/imgs/CPMH_vs_Avg_Selector_Days.png')
    """

    figsize(16, 8)
    sn.set()
    fig, ax = plt.subplots()
    ax.scatter(df[[x_column]], df[[y_column]], color='#ff9933', edgecolor='black')
    ax.set_title(title, fontsize=24, fontweight='bold')
    ax.set_xlabel(x_label, fontsize=16, fontweight='bold')
    ax.set_ylabel("CPMH change YoY", fontsize=16, fontweight='bold')
    ax.tick_params(axis="both", labelsize=14)
    ax.figure.savefig(figure)
