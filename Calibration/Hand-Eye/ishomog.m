%ISHOMOG	test if argument is a homogeneous transformation (4x4)


function h = ishomog(tr)
	h = all(size(tr) == [4 4]);