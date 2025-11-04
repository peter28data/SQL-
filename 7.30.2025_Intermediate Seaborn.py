#---------------------------Ch.3: Additional Plot Types-------------------------------
# Customize Heatmap
sns.heatmap(df_crosstab,
            annot=True,    # Annotations displays value in each cell
            fmt="d",
            cmap="YlGnBu",
            cbar=False,
            linewidths=.5)

# Correlation Matrix
sns.heatmap(df[cols].corr(),
            cmap='YlGnBu')


#-------------------------Ch.4: Creating Plots on Data Aware Grids--------------------

# FacetGrid define facets and map plottype
g.sns.FacetGrid(df,
                col='HIGHDEG')

g.map(sns.boxplot,
      'Tuition',
      order=['1', '2', '3', '4'])    # 4 graphs in row facetgrid

g.map(plt.scatter, 
      'Tuition',
      'SAT_AVG_ALL')



# Catplot is a shortcut to not define facets
sns.catplot(x="Tuition",
            data=df,
            col="HIGHDEG",
            kind="box")



# LMplot is a shortcut to not define facets and defaults to regression line
sns.lmplot(x="Tuition",
           y="SAT_AVG_ALL",
           data=df,
           col="HIGHDEG",
           fit_reg=False)    # Disabled regression line with false
           





# -----------------------------------------------------------------

# Relplot
sns.replot(x="age",
           y="rating",
           data=fifa_subset,
           kind="line")
plt.show()




# Boxplot in Catplot
sns.catplot(x="club",
            y="rating",
            data=fifa_subset,
            kind="box",
            order="Atletico Madrid", "Chelsea", "Napoli"])
plt.show()









