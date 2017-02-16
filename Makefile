.PHONY: newlib
# make newlib creates a new gap library.
# It needs input two arguments: NAME and DEPEND
newlib:
	touch $(NAME).g
# create the header
	echo "#-------" >> $(NAME).g
	echo "# GAP:" >> $(NAME).g
	echo "#-------" >> $(NAME).g
	echo "#" >> $(NAME).g
	echo "# Author: Hao-pin Wu <hxw132130@utdallas.edu>" >> $(NAME).g
	echo "# Last update: " `date +%Y-%m-%d` >> $(NAME).g
	echo "#-------" >> $(NAME).g
	echo >> $(NAME).g
	cp $(NAME).g $(NAME).gd
# finish the .g file
	echo "# dependency" >> $(NAME).g
	for i in $(DEPEND); do \
		echo "  Read( \"" `readlink -f $$i.g` "\" );" >> $(NAME).g; \
	done
	echo >> $(NAME).g
	echo "# include declaration file" >> $(NAME).g
	echo "  Read( \"" `readlink -f $(NAME).gd` "\" );" >> $(NAME).g
	echo >> $(NAME).g
	echo "# include implementation file" >> $(NAME).g
	echo "  Read( \""`readlink -f $(NAME).gi`"\" );" >> $(NAME).g
	echo >> $(NAME).g
# common parts of the .gd and .gi file
	echo "#-----" >> $(NAME).gd
	echo "# attribute(s)" >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo "# property(s)" >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo "# method(s)" >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo "# function(s)" >> $(NAME).gd
	echo "#-----" >> $(NAME).gd
	echo >> $(NAME).gd
	cp $(NAME).gd $(NAME).gi
# finish the .gd file
	sed -i '3a # Declaration file of $(NAME).g' $(NAME).gd
	sed -i '9a #-----\n# global variable(s)\n#-----\n' $(NAME).gd
# finish the .gi file
	sed -i '3a # Implementation file of $(NAME).g' $(NAME).gi
