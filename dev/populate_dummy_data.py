#!/usr/bin/python
import datetime
import requests
import simplejson
import random

headers = {"X-Parse-Application-Id": "AA59D96B6A746kultureapp",
           "X-Parse-Master-Key": "3MtwTKFDJaAFxeVnuar7QrzTBAVsFPBL"}

now = datetime.datetime.now()
parse_base_url = "http://kultureapp.herokuapp.com/parse"
usernames = ["biswa", "sada", "kapil", "ravi", "manoj", "priya"]
relations = [
   ("kapil", "sada", "KID"),
   ("kapil", "ravi", "KID"),
   ("kapil", "priya", "KID"),
   ("kapil", "biswa", "FAMILY"),
   ("kapil", "manoj", "FAMILY"),
]

video_ids = ["UWxoKb7Wk1o", "ADO6FnYj5E0", "g3Ciu0UnwZM", "_UR-l3QI2nE"]

texts = {"The Lion and the Mouse - part 1": "Once when a lion, the king of the jungle, was asleep, a little mouse began running up and down on him. This soon awakened the lion, who placed his huge paw on the mouse, and opened his big jaws to swallow him.",
         "The Lion and the Mouse - part 2": "Pardon, O King! cried the little mouse. Forgive me this time. I shall never repeat it and I shall never forget your kindness. And who knows, I may be able to do you a good turn one of these days!",
         "The Lion and the Mouse - part 3": "The lion was so tickled by the idea of the mouse being able to help him that he lifted his paw and let him go.",
         "The Lion and the Mouse - part 4": "Sometime later, a few hunters captured the lion, and tied him to a tree. After that they went in search of a wagon, to take him to the zoo.",
         "The Lion and the Mouse - part 5": "Short StoriesJust then the little mouse happened to pass by. On seeing the lion's plight, he ran up to him and gnawed away the ropes that bound him, the king of the jungle.",
         "The Lion and the Mouse - part 6": "Was I not right? said the little mouse, very happy to help the lion.",
         "The Lion and the Mouse - part 7": "MORAL: Small acts of kindness will be rewarded greatly!",
         "The Hare and the Tortoise- part 1": "There once was a speedy Hare who bragged about how fast he could run. Tired of hearing him boast, the Tortoise challenged him to a race. All the animals in the forest gathered to watch.",
         "The Hare and the Tortoise- part 2": "The Hare ran down the road for a while and then paused to rest. He looked back at the tortoise and cried out, How do you expect to win this race when you are walking along at your slow, slow pace?",
         "The Hare and the Tortoise- part 3": "The Hare stretched himself out alongside the road and fell asleep, thinking, There is plenty of time to relax.",
         "The Hare and the Tortoise- part 4": "The Tortoise walked and walked, never ever stopping until he came to the finish line.",
         "The Hare and the Tortoise- part 5": "The animals who were watching cheered so loudly for Tortoise that they woke up the Hare. The Hare stretched, yawned and began to run again, but it was too late. Tortoise had already crossed the finish line.",
         "The Hare and the Tortoise- part 6": "Moral: Slow and steady wins the race!"}


def delete_table(name):
   url = "/users" if name == 'User' else "/classes/%s" % name
   url = parse_base_url + url
   results = simplejson.loads(requests.get(url, headers=headers).text)['results']
   print "deleting %d objects from %s table" % (len(results), name)
   for i, x in enumerate(results):
      requests.delete("%s/%s" % (url, x["objectId"]), headers=headers)
      print '.',
      if i % 20 == 0:
         print
   requests.delete(url, headers=headers)
   print

print "deleting data..."
for table in ['User', 'Post', 'Relation']:
   delete_table(table)
   print '.',
print "clean!"

for username in usernames:
   requests.post(parse_base_url + "/users", headers=headers,
                 json=dict(username=username,
                           password=username,
                           email="%s@gmail.com" % username))
print "created users"

user_id_for_name = {u["username"]: u["objectId"]
                    for u in simplejson.loads(requests.get(parse_base_url + "/users",
                                                           headers=headers).text)['results']}
username_for_id = {v: k for k, v in user_id_for_name.items()}

for username1, username2, relationship in relations:
   requests.post(parse_base_url + "/classes/Relation", headers=headers,
                 json=dict(id1=user_id_for_name[username1],
                           id2=user_id_for_name[username2],
                           relation=relationship))
print "created relations"

family_for_parent = {}
kid_for_parent = {}

for parent, person, relation in relations:
   if relation == "FAMILY":
      family_for_parent.setdefault(parent, []).append(person)
   elif relation == "KID":
      kid_for_parent.setdefault(parent,[]).append(person)


tags = ['FUN', 'RESPECT', 'LEARN']

print "creating posts",
for parent in ["kapil"]:
   family = family_for_parent[parent]
   kids = kid_for_parent[parent]
   for i in range(50):
      kid = kids[i % len(kids)]
      post = {'approvalState': i % 2,
              'kidUserId': user_id_for_name[kid],
              'parentId': user_id_for_name[parent],
              'familyMemberId': user_id_for_name[family[i % len(family)]],
              'tag': tags[i % len(tags)],
              'isLiked': [False, True][i % 2],
              'likesCount': 0}
      postType = random.choice([1, 2, 3])
      if postType == 1:
         # text
         post.update({
            'text': texts.values()[i % len(texts)],
            'caption': texts.keys()[i % len(texts)],
            'postType': 1})
      elif postType == 2:
         # image
         post.update({
            'image': {'url': 'http://kultureapp.herokuapp.com/parse/files/AA59D96B6A746kultureapp/'
                             '8f054d17aa5ee61d11cea6a55c418499_image.png',
                      '__type': 'File',
                      'name': '8f054d17aa5ee61d11cea6a55c418499_image.png'},
            'caption': 'pic-%d for %s' % (i, kid),
            'postType': 2})
      elif postType == 3:
         # video
         post.update({
            'videoId': video_ids[i % len(video_ids)],
            'caption': 'a cool video-%d for %s' % (i, kid),
            'postType': 3})
      resp = requests.post(parse_base_url + "/classes/Post",
                           json=post, headers=headers)
      print ".",
print "\nDone"
