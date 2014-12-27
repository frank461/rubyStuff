#TODO: Lookup function, make variable names more 
#	   descriptive, more comments, function headers, and file header


#--------------------------------------------------------------------------
# class TNode
# 
# Description:		This class implements the node of the BST. Each node
#					holds a numeric value. It also has height and balance 
#					attributes used to decide when the tree needs to be
#					restrucutred. Every node also keeps track of its child,
#					left and right, nodes.
#--------------------------------------------------------------------------
class TNode
	attr_accessor :left, :right, :number, :height, :balance

	def initialize number
		@left = nil
		@right = nil
		@height = 0
		@balance = 0
		@number = number
	end
end


#-------------------------------------------------------------------------
# class Tree
#
# Description:		This class implements a binary search tree data 
#					structure. The tree accesess its nodes through the root
#					node. 
#
#-------------------------------------------------------------------------
class Tree
	THRESHOLD = 2	
	attr_accessor :root, :occupancy

	def initialize
		@occupancy = 0
		@root = nil
	end

	#---------------------------------------------------------------------
	# routine Name	-	Insert
	#
	# Description	-	This function inserts a new item into the tree. If
	#					the tree is empty then it assigns the root the 
	#					the new node. Otherwise, it delegates to the 
	#					private insert function.
	# Parameter Desc.
	#---------------------------------------------------------------------
	# num		the number that the new node will hold
	# <return>  the occupancy of the tree after the insertion
	#---------------------------------------------------------------------
	def Insert num
		if @occupancy == 0
			@root = TNode.new(num) 
		else
			@root = insert(@root, num)	
		end
		@occupancy += 1
	end
	
	
	#---------------------------------------------------------------------
	# routine Name	-	Remove	
	#
	# Description	-	This function removes a specified item from the 
	#					tree. If the tree is empty, then a message is 
	#					displayed. Otherwise, it delegates to the private
	#					remove function.
	# Parameter Desc.
	#---------------------------------------------------------------------
	# num		the number that is to be removed from the tree
	# <return>	The occupancy of the tree after a removal 
	#---------------------------------------------------------------------
	def Remove num
		# Can't remove from an empty tree! #	
		if @occupancy == 0
			puts "Tree is empty!"
		else
			@root = remove(@root, num) # Delegate to private remove 
			@occupancy -= 1 # Decrement occupancy after removal
		end
	end

    #---------------------------------------------------------------------
	# routine Name	-	WriteTree	
	#
	# Description	-	This function prints all the items of the tree
	#					by delegating to the private writeNodes function
	#					with @root as the parameter.
	# Parameter Desc.
	#---------------------------------------------------------------------
	# <return>	nil 
	#---------------------------------------------------------------------
	def WriteTree 
		writeNodes(@root)	
	end

	private
		
		#----------------------------------------------------------------
		# routine Name	-	writeNodes (private)
		#	
		# Description	-	Performs an in-order traversal on the tree and 
		#					displays the contents, height, and balance of 
		#					each node.
		# 
		# Parameter         Description
		#---------------------------------------------------------------
		# n					The node that is to be visited. The initial 
		#					call is always made by passing the root.
		# <return>			nil
		#---------------------------------------------------------------
		def writeNodes n
			# Go as far left as possible	
			if n.left != nil
				writeNodes(n.left)
			end

			# Display contents	
			puts "#{n.number} at h: #{n.height} w/ b: #{n.balance}"

			# Go right	
			if n.right != nil
				writeNodes(n.right)
			end
		end

		
		#-----------------------------------------------------------------
		# routine Name	-	shab (private)
		#
		# Description	-	Sets the height and balance of a node. Height
		#					is always 1 + the height of the tallest child.
		#					Balance is left child height - right child 
		#					height. If the balance of a node passes the 
		#					threshold it is removed and reinserted into the
		#					tree.
		# 
		# Parameter			Description
		#-----------------------------------------------------------------
		# t					The node whose height and balance will be set
		# <return>			The node whose height and balance has been set
		#-----------------------------------------------------------------
		def shab t
			
			# Case for leaf node. Height and balance are 0 #	
			if t.right == nil && t.left == nil
				t.balance = t.height = 0
			
			# Node with only right child #	
			elsif t.left == nil
				t.height = t.right.height + 1
				t.balance = -1 - t.right.height
			
			# Node with only left child #	
			elsif t.right == nil
				t.height = t.left.height + 1
				t.balance = t.left.height + 1
			
			# Node with two children #	
			else
				t.height = [t.left.height, t.right.height].max + 1
				t.balance = t.left.height - t.right.height
			end

			# Check if balance exceeds THRESHOLD #
			# If so remove the node and reinsert it #
			if t.balance.abs > THRESHOLD
				 number = t.number # hold on to number for reinsertion 
				 t  = remove(t, t.number)
				 @root = insert(@root, number)
			end

			t
		end

		
		#-----------------------------------------------------------------
		# routine Name	-	insert (private)
		#
		# Description	-	Inserts a new item into the tree. If the item 
		#					is smaller than the one being visited the 
		#					search for an insertion location goes left, 
		#					otherwise it goes right. When the left or right
		#					node is found to be nil the new item is 
		#					inserted at the nil node location. Inserting
		#					the same node decrements occupancy to 
		#					counteract the increment that occurs in the 
		#					calling function.
		# 
		# Parameter			Description
		#-----------------------------------------------------------------
		# t					The node that is being visited 
		# n					The item that is to be inserted 
		# <return>			The node whose height and balance has been set
		#-----------------------------------------------------------------
		def insert t, num
			# Check to go left	
			if num < t.number
				if t.left == nil
					t.left = TNode.new(num)
				else
					t.left = insert(t.left, num)
				end
			# Check to go right
			elsif t.number < num
				if t.right == nil
					t.right = TNode.new(num)
				else
					t.right = insert(t.right, num)
				end
			# Item already in the tree	
			else
				# Decrement occupancy to counteract the increment that 
				# occurs in the calling function
				@occupancy -= 1
			end
			
			t = shab(t) # Set the height and balance of each visited node
			t  # return t
		end

		def findMin t
			if t.left == nil
				return t.number	
			else
				return findMin(t.left)
			end
		end

		def remove t, n, fromSHAB = false
			# Check to go left	
			if n < t.number
				if t.left == nil
					puts "#{n} not in tree"
					
					# increment occupancy to nullify the decrement that 
					# occurs in the calling function
					@occupancy += 1
				else
					# Recursive call to remove on the left child	
					t.left = remove(t.left, n)
				end
			# Check to go right
			elsif t.number < n
				if t.right == nil
					puts "#{n} not in tree"
					
					# increment occupancy to nullify the decrement that 
					# occurs in the calling function
					@occupancy += 1
				else
					# Recursive call to remove on the right child	
					t.right = remove(t.right, n)
				end
			# Item is found
			else
				# Node only has a left child	
				if t.right == nil
					t = t.left
				# Node only has right child or has two children	
				else
					repNumber = findMin(t.right)
					t.number = repNumber	
					t.right = remove(t.right,repNumber)
				end
			end
			if !fromSHAB && t != nil
				t = shab(t)
			end
			t
		end
end
